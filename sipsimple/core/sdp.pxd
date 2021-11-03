# cython: language_level=3

from ._pjsip cimport (
    pj_pool_t,
    pjmedia_sdp_attr,
    pjmedia_sdp_bandw,
    pjmedia_sdp_conn,
    pjmedia_sdp_media,
    pjmedia_sdp_neg,
    pjmedia_sdp_session,
    pjmedia_sdp_session_ptr_const,
)
from .util cimport frozenlist

cdef class BaseSDPConnection(object):
    # attributes
    cdef pjmedia_sdp_conn _sdp_connection

    # private methods
    cdef pjmedia_sdp_conn* get_sdp_connection(self)

cdef class SDPConnection(BaseSDPConnection):
    # attributes
    cdef object _address
    cdef object _net_type
    cdef object _address_type

cdef class FrozenSDPConnection(BaseSDPConnection):
    # attributes
    cdef int initialized
    cdef readonly object address
    cdef readonly object net_type
    cdef readonly object address_type

cdef class SDPAttributeList(list):
    pass

cdef class FrozenSDPAttributeList(frozenlist):
    pass

cdef class SDPBandwidthInfoList(list):
    pass

cdef class FrozenSDPBandwidthInfoList(frozenlist):
    pass

cdef class BaseSDPSession(object):
    # attributes
    cdef pjmedia_sdp_session _sdp_session

    # private methods
    cdef pjmedia_sdp_session* get_sdp_session(self)

cdef class SDPSession(BaseSDPSession):
    # attributes
    cdef object _address
    cdef object _user
    cdef object _net_type
    cdef object _address_type
    cdef object _name
    cdef object _info
    cdef SDPConnection _connection
    cdef list _attributes
    cdef list _bandwidth_info
    cdef list _media

    # private methods
    cdef int _update(self) except -1

cdef class FrozenSDPSession(BaseSDPSession):
    # attributes
    cdef int initialized
    cdef readonly object address
    cdef readonly unsigned int id
    cdef readonly unsigned int version
    cdef readonly object user
    cdef readonly object net_type
    cdef readonly object address_type
    cdef readonly object name
    cdef readonly object info
    cdef readonly FrozenSDPConnection connection
    cdef readonly int start_time
    cdef readonly int stop_time
    cdef readonly FrozenSDPAttributeList attributes
    cdef readonly FrozenSDPBandwidthInfoList bandwidth_info
    cdef readonly frozenlist media

cdef class BaseSDPMediaStream(object):
    # attributes
    cdef pjmedia_sdp_media _sdp_media

    # private methods
    cdef pjmedia_sdp_media* get_sdp_media(self)

cdef class SDPMediaStream(BaseSDPMediaStream):
    # attributes
    cdef object _media
    cdef object _transport
    cdef list _formats
    cdef list _codec_list
    cdef object _info
    cdef SDPConnection _connection
    cdef SDPAttributeList _attributes
    cdef SDPBandwidthInfoList _bandwidth_info

    # private methods
    cdef int _update(self, SDPMediaStream media) except -1

cdef class FrozenSDPMediaStream(BaseSDPMediaStream):
    # attributes
    cdef int initialized
    cdef readonly object media
    cdef readonly int port
    cdef readonly object transport
    cdef readonly int port_count
    cdef readonly frozenlist formats
    cdef readonly frozenlist codec_list
    cdef readonly object info
    cdef readonly FrozenSDPConnection connection
    cdef readonly FrozenSDPAttributeList attributes
    cdef readonly FrozenSDPBandwidthInfoList bandwidth_info

cdef class BaseSDPAttribute(object):
    # attributes
    cdef pjmedia_sdp_attr _sdp_attribute

    # private methods
    cdef pjmedia_sdp_attr* get_sdp_attribute(self)

cdef class SDPAttribute(BaseSDPAttribute):
    # attributes
    cdef object _name
    cdef object _value

cdef class FrozenSDPAttribute(BaseSDPAttribute):
    # attributes
    cdef int initialized
    cdef readonly object name
    cdef readonly object value

cdef class BaseSDPBandwidthInfo(object):
    # attributes
    cdef pjmedia_sdp_bandw _sdp_bandwidth_info

    # private methods
    cdef pjmedia_sdp_bandw* get_sdp_bandwidth_info(self)

cdef class SDPBandwidthInfo(BaseSDPBandwidthInfo):
    # attributes
    cdef object _modifier
    cdef object _value

cdef class FrozenSDPBandwidthInfo(BaseSDPBandwidthInfo):
    # attributes
    cdef int initialized
    cdef readonly object modifier
    cdef readonly int value

cdef SDPSession SDPSession_create(pjmedia_sdp_session_ptr_const pj_session)
cdef FrozenSDPSession FrozenSDPSession_create(pjmedia_sdp_session_ptr_const pj_session)
cdef SDPMediaStream SDPMediaStream_create(pjmedia_sdp_media *pj_media)
cdef FrozenSDPMediaStream FrozenSDPMediaStream_create(pjmedia_sdp_media *pj_media)
cdef SDPConnection SDPConnection_create(pjmedia_sdp_conn *pj_conn)
cdef FrozenSDPConnection FrozenSDPConnection_create(pjmedia_sdp_conn *pj_conn)
cdef SDPAttribute SDPAttribute_create(pjmedia_sdp_attr *pj_attr)
cdef FrozenSDPAttribute FrozenSDPAttribute_create(pjmedia_sdp_attr *pj_attr)
cdef SDPBandwidthInfo SDPBandwidthInfo_create(pjmedia_sdp_bandw *pj_bandw)
cdef FrozenSDPBandwidthInfo FrozenSDPBandwidthInfo_create(pjmedia_sdp_bandw *pj_bandw)

cdef class SDPNegotiator(object):
    # attributes
    cdef pjmedia_sdp_neg* _neg
    cdef pj_pool_t *_pool
