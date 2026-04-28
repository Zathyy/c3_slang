module c3_slang;

import slang;

import std::collections::list;
import std::io::file;
import std::io::path;

fn int main(String[] args) 
{
	IGlobalSession* global_session = null;
	SlangResult result = slang::create_global_session(&global_session);
	if (slang::failed(result)) {
		log::error("failed to create global ses: %s", result);
		return -1;
	}

	defer slang::shutdown();
	defer global_session.free();

	CompilerOptionEntry[*] options = {
		{
			CompilerOptionName.MATRIX_LAYOUT_ROW,
			{
				.kind = CompilerOptionValueKind.INT,
				.int_value_0 = 1
			}
		},
		{
			CompilerOptionName.VULKAN_USE_ENTRYPOINT_NAME,
			{
				.kind = CompilerOptionValueKind.INT,
				.int_value_0 = 1
			}
		},
		{
			CompilerOptionName.VULKAN_BIND_SHIFT, 
			{ 
				.kind = CompilerOptionValueKind.INT, 
				.int_value_0 = (int)BindingType.SLANG_BINDING_TYPE_SAMPLER << 24 | 0,
				.int_value_1 = 128
			}
		},
		{
			CompilerOptionName.VULKAN_BIND_SHIFT, 
			{ 
				.kind = CompilerOptionValueKind.INT, 
				.int_value_0 = (int)BindingType.SLANG_BINDING_TYPE_CONSTANT_BUFFER << 24 | 0,
				.int_value_1 = 256
			}
		},
		{
			CompilerOptionName.VULKAN_BIND_SHIFT, 
			{ 
				.kind = CompilerOptionValueKind.INT, 
				.int_value_0 = (int)BindingType.SLANG_BINDING_TYPE_MUTABLE_TYPED_BUFFER << 24 | 0,
				.int_value_1 = 384
			}
		},
		{
			CompilerOptionName.VULKAN_BIND_SHIFT, 
			{ 
				.kind = CompilerOptionValueKind.INT, 
				.int_value_0 = (int)BindingType.SLANG_BINDING_TYPE_MUTABLE_RAW_BUFFER << 24 | 0,
				.int_value_1 = 384
			}
		},
		{
			CompilerOptionName.VULKAN_BIND_SHIFT, 
			{ 
				.kind = CompilerOptionValueKind.INT, 
				.int_value_0 = (int)BindingType.SLANG_BINDING_TYPE_MUTABLE_FLAG << 24 | 0,
				.int_value_1 = 384
			}
		}
	}; 

	SessionDesc desc;
	desc.flags = slang::SESSION_FLAGS_NONE;
	desc.skip_spirv_validation = false;
	desc.structure_size = SessionDesc.sizeof;
	
	TargetDesc target;
	target.structure_size = TargetDesc.sizeof;
	target.compiler_option_entries = &options;
	target.compiler_option_entry_count = (uint)options.len;
	target.format =	SlangCompileTarget.SLANG_SPIRV;
	target.profile = global_session.find_profile("spirv_1_5");

	CChar*[*] paths = { "resources" };

	desc.targets = &target;
	desc.target_count = 1;
	desc.search_paths = &paths;
	desc.search_path_count = 1;

	ISession* session;
	result = global_session.vtable.create_session(global_session, &desc, &session);
	if (slang::failed(result)) {
		log::error("err");
	}

	String path_str = "./resources/shader.slang";
	Path? path = path_str.to_absolute_path(tmem);
	if (catch err = path) {
		log::error("Failed to get absolute path");
		return -1;
	}

	IBlob* diagnostics;
	IModule* slang_module = session.vtable.load_module(session, (CChar*)path.path_string, &diagnostics);
	if (diagnostics) 
	{
		log::error("Failed to load module: %s", (CChar*)diagnostics.get_buffer_ptr());
		diagnostics.free();
		return -1;
	}

	if (slang_module == null) {
		log::error("Failed to load shader: %s", path);
		return -1;
	}

	defer slang_module.free();

	List{ IEntryPoint* } entry_points;
	entry_points.tinit(5);

	int entry_point_count = slang_module.vtable.get_defined_entry_point_count(slang_module);
	for (int i = 0; i < entry_point_count; i++) 
	{
		IEntryPoint* entry;
		result = slang_module.vtable.get_defined_entry_point(slang_module, i, &entry);
		if (slang::failed(result) || entry == null) {
			log::error("Failed to get entry point: %s", i);
			continue;
		}

		entry_points.push(entry);
	}	


	List{ IComponentType* } components;
	components.tinit(5);
	components.push((IComponentType*)slang_module);

	foreach (entry : entry_points) 
	{
		components.push((IComponentType*)entry);
	}

	IComponentType* composed_program;
	result = session.vtable.create_composite_component_type(
		session,
		components.entries,
		(int)components.len(),
		&composed_program,
		&diagnostics
	);

	if (diagnostics) 
	{
		log::error("failed to compose program: %s", (CChar*)diagnostics.get_buffer_ptr());
		return -1;
	}

	if (!composed_program) 
	{
		log::error("failed to compose program");
		return -1;
	}
	defer composed_program.free();

	IComponentType* linked_program;
	result = composed_program.vtable.link(composed_program, &linked_program, &diagnostics);
	if (diagnostics || !linked_program) 
	{
		log::error("Failed to link program!");
		return 0;
	}
	defer linked_program.free();

	foreach (entry : entry_points)
	{
		entry.free();
	}

	IBlob* code;
	result = linked_program.vtable.get_target_code(linked_program, 0, &code, &diagnostics);
	if (slang::failed(result)) {
		if (diagnostics) {
			log::error("Failed to load module: %s", (CChar*)diagnostics.get_buffer_ptr());
			return -1;
		}

		log::error("failed! %s", result);
		return -1;
	}
	defer code.free();

	char* buffer = (char*)code.get_buffer_ptr();
	usz buffer_size = code.get_buffer_size();
	(void)file::save("./resources/shader.spv", buffer[:buffer_size]);

	log::info("sucessfully compiled shader!");

	return 0;
}