module slang;

// has to be 0 for some reason
const int API_VERSION = 0;
alias SlangResult = int;
const SlangResult OK = 0;

alias SlangInt = int;
alias SlangUint = uint;

fn bool failed(SlangResult result) @inline
{
	return result < 0;
}

fn bool succeeded(SlangResult result) @inline
{
	return result >= 0;
}

extern fn SlangResult create_global_session_impl(
	int api_version,
	IGlobalSession** out_session
) @extern("slang_createGlobalSession") @private;

fn SlangResult create_global_session(IGlobalSession** out_session)
{
	return create_global_session_impl(API_VERSION, out_session);
}

extern fn IBlob* create_blob(
	void* data,
	usz size
) @extern("slang_createBlob");

extern fn void shutdown();

extern fn CChar* get_last_error_message()
@extern("getLastInternalErrorMessage");