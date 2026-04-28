module slang::reflection;

typedef ShaderReflection = void;
typedef EntryPointReflection = void;
typedef VariableReflection = void;
typedef TypeReflection = void;
alias ProgramLayout = ShaderReflection;

extern fn SlangUint get_entry_point_count(ShaderReflection* self)
@extern("spReflection_getEntryPointCount");

extern fn EntryPointReflection* get_entry_point_by_index(
	ShaderReflection* self,
	SlangUint index)
@extern("spReflection_getEntryPointByIndex");

extern fn EntryPointReflection* find_entry_point_by_name(
	ShaderReflection* self,
	CChar* name) 
@extern("spReflection_findEntryPointByName");

extern fn CChar* get_name(EntryPointReflection* self)
@extern("spReflectionEntryPoint_getName");

extern fn uint get_parameter_count(EntryPointReflection* self)
@extern("spReflectionEntryPoint_getParameterCount");

extern fn VariableReflection* get_parameter_by_index(EntryPointReflection* self)
@extern("spReflectionEntryPoint_getParameterByIndex");

extern fn SlangStage get_stage(EntryPointReflection* self)
@extern("spReflectionEntryPoint_getStage");

extern fn void getComputeThreadGroupSize(
	EntryPointReflection* self,
	SlangUint axis_count,
	SlangUint* out_size_along_axis)
@extern("spReflectionEntryPoint_getComputeThreadGroupSize");

