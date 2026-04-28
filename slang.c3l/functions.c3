module slang;

alias QueryInterfaceFn = fn SlangResult(void* self, Guid* iid, void** out_object);
alias AddRefFn = fn uint(void* self);
alias ReleaseFn = fn uint(void* self);

// -- Global session --
alias CreateSession = fn SlangResult(void* self, void* desc, ISession** out_session);
alias FindProfile = fn SlangProfileID(void* self, CChar* name);
alias SetDownstreamCompilerPath = fn void(void* self, int pass_through, CChar* path);
alias SetDownstreamCompilerPrelude = fn void(void* self, int pass_through, CChar* prelude_text);
alias GetDownstreamCompilerPrelude = fn void(void* self, int pass_through, IBlob** out_prelude);
alias GetBuildTagString = fn CChar*(void* self);
alias SetDefaultDownstreamCompiler = fn SlangResult(void* self, int source_language, int default_compiler);
alias GetDefaultDownstreamCompiler = fn int(void* self, int source_language);
alias SetLanguagePrelude = fn void(void* self, int source_language, CChar* prelude_text);
alias GetLanguagePrelude = fn void(void* self, int source_language, IBlob** out_prelude);
alias CreateCompileRequest = fn SlangResult(void* self, ICompileRequest** out_request);
alias AddBuiltins = fn void(void* self, CChar* source_path, CChar* source_string);
alias SetSharedLibraryLoader = fn void(void* self, void* loader);
alias GetSharedLibraryLoader = fn void*(void* self);
alias CheckCompileTargetSupport = fn SlangResult(void* self, int target);
alias CheckPassThroughSupport = fn SlangResult(void* self, int pass_through);
alias CompileCoreModule = fn SlangResult(void* self, int flags);
alias LoadCoreModule = fn SlangResult(void* self, void* core_module, usz core_module_size_in_bytes);
alias FindCapability = fn int(void* self, CChar* name);
alias SetDownstreamCompilerForTransition = fn void(void* self, void* source, void* target, int compiler);
alias SetSPIRVCoreGrammar = fn SlangResult(void* self, CChar* json_path);
alias ParseCommandLineArguments = fn SlangResult(void* self, int argc, CChar** argv, void* out_session_desc, ISlangUnknown** out_aux_allocation);
alias GetSessionDescDigest = fn SlangResult(void* self, void* desc, IBlob** out_blob);
alias CompileBuiltinModule = fn SlangResult(void* self, CChar* name, int flags);
alias LoadBuiltinModule = fn SlangResult(void* self, CChar* name, void* module_data, usz size_in_bytes);
alias SaveBuiltinModule = fn SlangResult(void* self, CChar* name, int archive_type, IBlob** out_blob);
// -- Global session --


// -- Session --
alias GetGlobalSession = fn IGlobalSession*(void* self);
alias LoadModule = fn IModule*(void* self, CChar* name, IBlob** out_diagnostics);
alias LoadModuleFromSource = fn IModule*(void* self, CChar* name, IBlob** out_blob);
alias CreateCompositeComponentType = fn SlangResult(
	void* self, 
	IComponentType** component_types,
	int component_type_count,
	IComponentType** out_composite_component_type,
	IBlob** out_diagnostics = null
);
alias GetLoadedModuleCount = fn int(void* self);
alias GetLoadedModule = fn IModule*(void* self, int index);
alias LoadModuleFromSourceString = fn IModule*(void* self, CChar* name, CChar* path, CChar* string, IBlob** out_diagnostics = null);

alias FindEntryPointByName = fn SlangResult(void* self, CChar* name, IEntryPoint** out_entry_point);
alias GetDefinedEntryPointCount = fn int(void* self);
alias GetDefinedEntryPoint = fn SlangResult(void* self, int index, IEntryPoint** out_entry_point);
alias Serialize = fn SlangResult(void* self, IBlob** out_blob);
alias WriteToFile = fn SlangResult(void* self, CChar* file_name);
alias GetName = fn CChar*(void* self);
alias GetFilePath = fn CChar*(void* self);
alias GetUniqueIdentity = fn CChar*(void* self);
alias FindAndCheckEntryPoint = fn SlangResult(
	void* self,
	SlangStage stage,
	IEntryPoint** out_entry_point,
	IBlob** out_diagnostics
);
alias GetDependencyFileCount = fn int(void* self);
alias GetDependencyFilePath = fn CChar*(void* self, int index);
// -- Session --

alias Disassemble = fn SlangResult(void* self, IBlob** out_disassembled_blob);

alias GetBufferPointerFn = fn void*(void* self);
alias GetBufferSizeFn = fn usz(void* self);

alias LoadFile = fn SlangResult(void* self, CChar* path, IBlob** out_blob);
alias CastAs = fn void*(void* self, Guid* guid);

alias GetSession = fn ISession*(void* self);

alias FindEntryPointByName_2 = fn SlangResult(
	void* self,
	CChar* name,
	IEntryPoint** out_entry_point
);

alias GetEntryPointCode = fn SlangResult(
	void* self,
	int entry_point_index,
	int target_index,
	IBlob** out_code,
	IBlob** out_diagnostics = null
);

alias GetTargetCode = fn SlangResult(
	void* self,
	int target_index,
	IBlob** out_code,
	IBlob** out_diagnostics = null
);

alias CloneFn = fn void*(void* self, Guid* guid);

alias LinkFn = fn SlangResult(void* self, IComponentType** out_linked_component_types, IBlob** out_diagnostics = null);