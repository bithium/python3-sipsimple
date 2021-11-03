# cython: language_level=3

from ._pjsip cimport (
    pj_caching_pool,
    pj_pool_t,
    pj_sockaddr_in,
    pjmedia_endpt,
    pjsip_endpoint,
    pjsip_tpfactory,
    pjsip_transport,
)
from .util cimport PJSTR

cdef class PJLIB:
    # attributes
    cdef int _init_done

cdef class PJCachingPool:
    # attributes
    cdef int _init_done
    cdef pj_caching_pool _obj

cdef class PJSIPEndpoint(object):
    # attributes
    cdef pjsip_endpoint *_obj
    cdef pj_pool_t *_pool
    cdef pjsip_transport *_udp_transport
    cdef pjsip_tpfactory *_tcp_transport
    cdef pjsip_tpfactory *_tls_transport
    cdef int _tls_verify_server
    cdef PJSTR _tls_ca_file
    cdef PJSTR _tls_cert_file
    cdef PJSTR _tls_privkey_file
    cdef object _local_ip_used
    cdef int _tls_timeout

    # private methods
    cdef int _make_local_addr(self, pj_sockaddr_in *local_addr, object ip_address, int port) except -1
    cdef int _start_udp_transport(self, int port) except -1
    cdef int _stop_udp_transport(self) except -1
    cdef int _start_tcp_transport(self, int port) except -1
    cdef int _stop_tcp_transport(self) except -1
    cdef int _start_tls_transport(self, port) except -1
    cdef int _stop_tls_transport(self) except -1
    cdef int _set_dns_nameservers(self, list servers) except -1

cdef class PJMEDIAEndpoint(object):
    # attributes
    cdef pjmedia_endpt *_obj
    cdef pj_pool_t *_pool
    cdef int _has_audio_codecs
    cdef int _has_video
    cdef int _has_ffmpeg_video
    cdef int _has_vpx

    # private methods
    cdef list _get_codecs(self)
    cdef list _get_all_codecs(self)
    cdef list _get_current_codecs(self)
    cdef int _set_codecs(self, list req_codecs) except -1
    cdef list _get_video_codecs(self)
    cdef list _get_all_video_codecs(self)
    cdef list _get_current_video_codecs(self)
    cdef int _set_video_codecs(self, list req_codecs) except -1
    cdef void _audio_subsystem_init(self, PJCachingPool caching_pool)
    cdef void _audio_subsystem_shutdown(self)
    cdef void _video_subsystem_init(self, PJCachingPool caching_pool)
    cdef void _video_subsystem_shutdown(self)
    cdef void _set_h264_options(self, object profile, int level)
    cdef void _set_video_options(self, tuple max_resolution, int max_framerate, float max_bitrate)
