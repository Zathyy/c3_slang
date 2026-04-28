module slang;

alias SlangResult = int;

const SlangResult OK = 0;

fn bool failed(SlangResult result) @inline {
	return result < 0;
}

fn bool succeeded(SlangResult result) @inline {
	return result >= 0;
}

extern fn SlangResult create_global_session(
	int api_version,
	IGlobalSession** out_session
) @extern("slang_createGlobalSession");

extern fn IBlob* create_blob(
	void* data,
	usz size
) @extern("slang_createBlob");

extern fn void shutdown();

extern fn CChar* get_last_error_message()
@extern("getLastInternalErrorMessage");