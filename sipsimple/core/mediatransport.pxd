# cython: language_level=3

from ._pjsip cimport (
    pj_ice_sess,
    pj_ice_sess_cand,
    pj_ice_sess_check,
    pj_ice_strans_op,
    pj_ice_strans_state,
    pj_math_stat,
    pj_mutex_t,
    pj_pool_t,
    pjmedia_rtcp_stream_stat,
    pjmedia_stream,
    pjmedia_stream_info,
    pjmedia_transport,
    pjmedia_transport_info,
    pjmedia_vid_stream,
    pjmedia_vid_stream_info,
)
from .sdp cimport BaseSDPMediaStream, BaseSDPSession
from .sound cimport AudioMixer
from .ua cimport PJSIPUA, Timer
from .video cimport LocalVideoStream, RemoteVideoStream

cdef class ICECandidate(object):
    # attributes
    cdef readonly str component
    cdef readonly str type
    cdef readonly str address
    cdef readonly int port
    cdef readonly int priority
    cdef readonly str rel_address

cdef class ICECheck(object):
    cdef readonly ICECandidate local_candidate
    cdef readonly ICECandidate remote_candidate
    cdef readonly str state
    cdef readonly int nominated

cdef class RTPTransport(object):
    # attributes
    cdef object __weakref__
    cdef object weakref
    cdef int _af
    cdef pj_mutex_t *_lock
    cdef pj_pool_t *_pool
    cdef pjmedia_transport *_obj
    cdef pjmedia_transport *_wrapped_transport
    cdef ICECheck _rtp_valid_pair
    cdef object _encryption
    cdef readonly object ice_stun_address
    cdef readonly object ice_stun_port
    cdef readonly object state
    cdef readonly object use_ice

    # private methods
    cdef PJSIPUA _check_ua(self)
    cdef void _get_info(self, pjmedia_transport_info *info)
    cdef int _init_local_sdp(self, BaseSDPSession local_sdp, BaseSDPSession remote_sdp, int sdp_index)
    cdef int _ice_active(self)

cdef class MediaCheckTimer(Timer):
    # attributes
    cdef int media_check_interval

cdef class SDPInfo(object):
    # attributes
    cdef BaseSDPMediaStream _local_media
    cdef BaseSDPSession _local_sdp
    cdef BaseSDPSession _remote_sdp
    cdef public int index

cdef class AudioTransport(object):
    # attributes
    cdef object __weakref__
    cdef object weakref
    cdef int _is_offer
    cdef int _is_started
    cdef int _slot
    cdef int _volume
    cdef unsigned int _packets_received
    cdef unsigned int _vad
    cdef pj_mutex_t *_lock
    cdef pj_pool_t *_pool
    cdef pjmedia_stream *_obj
    cdef pjmedia_stream_info _stream_info
    cdef Timer _timer
    cdef readonly object direction
    cdef readonly AudioMixer mixer
    cdef readonly RTPTransport transport
    cdef SDPInfo _sdp_info

    # private methods
    cdef PJSIPUA _check_ua(self)
    cdef int _cb_check_rtp(self, MediaCheckTimer timer) except -1

cdef class VideoTransport(object):
    # attributes
    cdef object __weakref__
    cdef object weakref
    cdef int _is_offer
    cdef int _is_started
    cdef unsigned int _packets_received
    cdef pj_mutex_t *_lock
    cdef pj_pool_t *_pool
    cdef pjmedia_vid_stream *_obj
    cdef pjmedia_vid_stream_info _stream_info
    cdef Timer _timer
    cdef readonly object direction
    cdef readonly RTPTransport transport
    cdef SDPInfo _sdp_info
    cdef readonly LocalVideoStream local_video
    cdef readonly RemoteVideoStream remote_video

    # private methods
    cdef PJSIPUA _check_ua(self)
    cdef int _cb_check_rtp(self, MediaCheckTimer timer) except -1

cdef void _RTPTransport_cb_ice_complete(pjmedia_transport *tp, pj_ice_strans_op op, int status) with gil
cdef void _RTPTransport_cb_ice_state(pjmedia_transport *tp, pj_ice_strans_state prev, pj_ice_strans_state curr) with gil
cdef void _RTPTransport_cb_ice_stop(pjmedia_transport *tp, char *reason, int err) with gil
cdef void _RTPTransport_cb_zrtp_secure_on(pjmedia_transport *tp, char* cipher) with gil
cdef void _RTPTransport_cb_zrtp_secure_off(pjmedia_transport *tp) with gil
cdef void _RTPTransport_cb_zrtp_show_sas(pjmedia_transport *tp, char* sas, int verified) with gil
cdef void _RTPTransport_cb_zrtp_confirm_goclear(pjmedia_transport *tp) with gil
cdef void _RTPTransport_cb_zrtp_show_message(pjmedia_transport *tp, int severity, int subCode) with gil
cdef void _RTPTransport_cb_zrtp_negotiation_failed(pjmedia_transport *tp, int severity, int subCode) with gil
cdef void _RTPTransport_cb_zrtp_not_supported_by_other(pjmedia_transport *tp) with gil
cdef void _RTPTransport_cb_zrtp_ask_enrollment(pjmedia_transport *tp, int info) with gil
cdef void _RTPTransport_cb_zrtp_inform_enrollment(pjmedia_transport *tp, int info) with gil
cdef void _AudioTransport_cb_dtmf(pjmedia_stream *stream, void *user_data, int digit) with gil
cdef ICECandidate ICECandidate_create(pj_ice_sess_cand *cand)
cdef ICECheck ICECheck_create(pj_ice_sess_check *check)
cdef str _ice_state_to_str(int state)
cdef dict _extract_ice_session_data(pj_ice_sess *ice_sess)
cdef object _extract_rtp_transport(pjmedia_transport *tp)
cdef dict _pj_math_stat_to_dict(pj_math_stat *stat)
cdef dict _pjmedia_rtcp_stream_stat_to_dict(pjmedia_rtcp_stream_stat *stream_stat)
