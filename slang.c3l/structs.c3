module slang;

/// The padding void* / void*[x] is for functions not implemented

struct Guid
{
	uint data1;
	ushort data2;
	ushort data3;
	char[8] data4;
}

struct CompilerOptionValue
{
	CompilerOptionValueKind kind;
	int int_value_0;
	int int_value_1;
	CChar* stringValue0;
	CChar* stringValue1;
}

struct CompilerOptionEntry
{
	CompilerOptionName name;
	CompilerOptionValue value;
}

struct ISlangUnknownVTable @private
{
    QueryInterfaceFn query_interface;
    AddRefFn add_ref;
    ReleaseFn release;
}

struct ISlangUnknown 
{
    ISlangUnknownVTable* vtable;
}

struct ISlangCastableVTable @private 
{
	inline ISlangUnknownVTable base;
	CastAs cast_as; 
}

struct ISlangCastable @private
{
	ISlangCastableVTable* vtable;
}

struct ISlangClonableVTable @private
{
	inline ISlangCastableVTable base;
	CloneFn clone;
}

struct ISlangClonable
{
	ISlangClonableVTable* vtable;
}

struct IGlobalSessionVTable @private {
    inline ISlangUnknownVTable base; 
    CreateSession create_session;
	FindProfile find_profile;
	SetDownstreamCompilerPath set_downstream_compiler_path;
	SetDownstreamCompilerPrelude set_downstream_compiler_prelude;
	GetDownstreamCompilerPrelude get_downstream_compiler_prelude;
	GetBuildTagString get_build_tag_string;
	SetDefaultDownstreamCompiler set_default_downstream_compiler;
	GetDefaultDownstreamCompiler get_default_downstream_compiler;
	SetLanguagePrelude set_language_prelude;
	GetLanguagePrelude get_language_prelude;
	CreateCompileRequest create_compile_request;
	AddBuiltins add_builtins;
	SetSharedLibraryLoader set_shared_library_loader;
	GetSharedLibraryLoader get_shared_library_loader;
	CheckCompileTargetSupport check_compile_target_support;
	CheckPassThroughSupport check_pass_through_support;
	CompileCoreModule compile_core_module;
	LoadCoreModule load_core_module;
	FindCapability find_capability;
	SetDownstreamCompilerForTransition set_downstream_compiler_for_transition;
	SetSPIRVCoreGrammar set_spirv_core_grammar;
	ParseCommandLineArguments parse_command_line_arguments;
	GetSessionDescDigest get_session_desc_digest;
	CompileBuiltinModule compile_builtin_module;
	LoadBuiltinModule load_builtin_module;
	SaveBuiltinModule  save_builtin_module;
}

struct IGlobalSession 
{
	IGlobalSessionVTable* vtable;
}

<*
	@param [&in] desc : "Session description"
	@param [&inout] out_session : "the created session"
*>
fn SlangResult IGlobalSession.create_session(&self, SessionDesc* desc, ISession** out_session)
{
	assert(self.vtable);
	return self.vtable.create_session(self, desc, out_session);
}

<*
	@param [&in] name : "profile name to find"
*>
fn SlangProfileID IGlobalSession.find_profile(&self, CChar* name)
{
	assert(self.vtable);
	return self.vtable.find_profile(self, name);
}

fn void IGlobalSession.free(&self)
{
	if (self.vtable) 
	{
		self.vtable.base.release(self);
	}
}

struct ICompileRequestVTable @private
{
	int temp;
}

struct ICompileRequest 
{
	ICompileRequestVTable* vtable;
}

struct ISlangFileSystemVTable @private 
{
	inline ISlangCastable base;
	LoadFile load_file;
}

struct ISlangFileSystem 
{
	ISlangFileSystemVTable* vtable;
}

struct TargetDesc 
{
	usz structure_size;
	SlangCompileTarget format;
	SlangProfileID profile;
	SlangTargetFlags flags;
	SlangFloatingPointMode floating_point_mode;
	SlangLineDirectiveMode line_directive_mode;
	bool force_glsl_scalar_buffer_layout;
	CompilerOptionEntry* compiler_option_entries;
	uint compiler_option_entry_count;
}

struct SessionDesc 
{
	usz structure_size;
	TargetDesc* targets;
	int target_count;
	SessionFlags flags;
	SlangMatrixLayoutMode default_matrix_layout_mode;
	CChar** search_paths;
	int search_path_count;
	PreprocessorMacroDesc* proprocessor_macros;
	int proprocessor_macro_count;
	bool skip_spirv_validation;
}

struct ISessionVTable @private
{
	inline ISlangUnknownVTable base;
	GetGlobalSession get_global_session;
	LoadModule load_module;
	LoadModuleFromSource load_module_from_source;
	CreateCompositeComponentType create_composite_component_type;
	void*[7] padding_7;
	CreateCompileRequest create_compile_request;
	void*[2] padding_2;
	GetLoadedModuleCount get_loaded_module_count;
	GetLoadedModule get_loaded_module;
	void* padding_1;
	LoadModuleFromSourceString load_module_from_source_string;
	void*[3] padding_2_2;
}

struct ISession
{
	ISessionVTable* vtable;
}

struct IEntryPointVTable @private
{
	inline IComponentTypeVTable base;
	void* padding;
}

struct IEntryPoint 
{
	IEntryPointVTable* vtable;
}

fn void IEntryPoint.free(&self)
{
	if (self.vtable) 
	{
		self.vtable.base.base.release(self);
	}
}

struct IBlobVTable @private
{
	inline ISlangUnknownVTable base;
	GetBufferPointerFn get_buffer_ptr;
	GetBufferSizeFn get_buffer_size;
}

struct IBlob
{
	IBlobVTable* vtable;
}

fn void* IBlob.get_buffer_ptr(&self)
{
	if (!self.vtable) {
		return null;
	}
	return self.vtable.get_buffer_ptr(self);
}

fn usz IBlob.get_buffer_size(&self)
{
	if (!self.vtable) {
		return 0;
	}
	return self.vtable.get_buffer_size(self);
}

fn void IBlob.free(&self)
{
	if (self.vtable) 
	{
		self.vtable.base.release(self);
		self.vtable = null;
	}

}

struct IComponentTypeVTable @private
{
	inline ISlangUnknownVTable base;
	GetSession get_session;
	void*[2] padding;
	GetEntryPointCode get_entry_point_code;
	void*[3] padding_1;
	LinkFn link;
	void*[3] padding_2;
	GetTargetCode get_target_code;
	void*[2] padding_3;
}

struct IComponentType {
	IComponentTypeVTable* vtable;
}

fn void IComponentType.free(&self) 
{
	if (self.vtable) 
	{
		self.vtable.base.release(self);
		self.vtable = null;
	}
}

struct IModuleVTable @private
{
	inline IComponentTypeVTable base;
	FindEntryPointByName find_entry_point_by_name;
	GetDefinedEntryPointCount get_defined_entry_point_count;
	GetDefinedEntryPoint get_defined_entry_point;
	Serialize serialize;
	WriteToFile write_to_file;
	GetName get_name;
	GetFilePath get_file_path;
	GetUniqueIdentity get_unique_identity;
	FindAndCheckEntryPoint find_and_check_entry_point;
	GetDependencyFileCount get_dependency_file_count;
	GetDependencyFilePath get_dependency_file_path;
	void* padding;
	Disassemble disassemble;
}

struct IModule 
{
	IModuleVTable* vtable;
}

fn void IModule.free(&self)
{
	if (self.vtable) 
	{
		self.vtable.base.base.release(self);
		self.vtable = null;
	}
}

struct PreprocessorMacroDesc
{
    CChar* name;
    CChar* value;
}
