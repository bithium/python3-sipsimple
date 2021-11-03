# cython: language_level=3

from ._pjsip cimport (
        pj_pool_t,
        pj_str_t,
        pjsip_msg,
        pjsip_param,
        pjsip_sip_uri,
        pjsip_tx_data,
)

cdef class frozenlist:
    # attributes
    cdef int initialized
    cdef list list
    cdef long hash

cdef class frozendict:
    # attributes
    cdef int initialized
    cdef dict dict
    cdef long hash

cdef class PJSTR:
    # attributes
    cdef pj_str_t pj_str
    cdef object str

cdef int _str_to_pj_str(object string, pj_str_t *pj_str) except -1
cdef object _pj_str_to_bytes(pj_str_t pj_bytes)
cdef object _pj_str_to_str(pj_str_t pj_str)
cdef object _pj_status_to_str(int status)
cdef object _pj_status_to_def(int status)
cdef object _pj_buf_len_to_str(object buf, int buf_len)
cdef object _buf_to_str(object buf)
cdef object _str_as_str(object string)
cdef object _str_as_size(object string)

cdef dict _pjsip_param_to_dict(pjsip_param *param_list)
cdef int _dict_to_pjsip_param(object params, pjsip_param *param_list, pj_pool_t *pool)
cdef int _pjsip_msg_to_dict(pjsip_msg *msg, dict info_dict) except -1
cdef int _is_valid_ip(int af, object ip) except -1
cdef int _get_ip_version(object ip) except -1
cdef int _add_headers_to_tdata(pjsip_tx_data *tdata, object headers) except -1
cdef int _remove_headers_from_tdata(pjsip_tx_data *tdata, object headers) except -1
