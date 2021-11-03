# cython: language_level=3

from ._pjsip cimport (
    pj_pool_t,
    pjsip_cred_info,
    pjsip_sip_uri,
    pjsip_sip_uri,
)

from .util cimport frozendict

cdef class BaseCredentials:
    # attributes
    cdef pjsip_cred_info _credentials

    # private methods
    cdef pjsip_cred_info* get_cred_info(self)

cdef class Credentials(BaseCredentials):
    # attributes
    cdef object _username
    cdef object _realm
    cdef object _password
    cdef bint _digest

cdef class FrozenCredentials(BaseCredentials):
    # attributes
    cdef int initialized
    cdef readonly object username
    cdef readonly object realm
    cdef readonly object password
    cdef readonly bint digest

cdef class BaseSIPURI:
    pass

cdef class SIPURI(BaseSIPURI):
    # attributes
    cdef public object user
    cdef public object password
    cdef public object host
    cdef public bint secure
    cdef public dict parameters
    cdef public dict headers
    cdef object _port

cdef class FrozenSIPURI(BaseSIPURI):
    # attributes
    cdef int initialized
    cdef readonly object user
    cdef readonly object password
    cdef readonly object host
    cdef readonly object port
    cdef readonly bint secure
    cdef readonly frozendict parameters
    cdef readonly frozendict headers

cdef SIPURI SIPURI_create(pjsip_sip_uri *base_uri)
cdef FrozenSIPURI FrozenSIPURI_create(pjsip_sip_uri *base_uri)
cdef int _BaseSIPURI_to_pjsip_sip_uri(BaseSIPURI uri, pjsip_sip_uri *pj_uri, pj_pool_t *pool) except -1
