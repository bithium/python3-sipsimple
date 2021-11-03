# cython: language_level=3

from ._pjsip cimport (
    PJ_THREAD_DESC_SIZE,
    pj_mutex_t,
    pj_pool_t,
    pj_rwmutex_t,
    pj_stun_config,
    pj_stun_nat_detect_result_ptr_const,
    pj_thread_t,
    pjsip_module,
    pjsip_rx_data,
    pjsip_tx_data,
)
from .lib cimport PJLIB, PJCachingPool, PJSIPEndpoint, PJMEDIAEndpoint
from .util cimport PJSTR

ctypedef int (*timer_callback)(object, object) except -1
cdef class Timer(object):
    # attributes
    cdef int _scheduled
    cdef double schedule_time
    cdef timer_callback callback
    cdef object obj

    # private methods
    cdef int schedule(self, float delay, timer_callback callback, object obj) except -1
    cdef int cancel(self) except -1
    cdef int call(self) except -1

cdef class PJSIPThread(object):
    # attributes
    cdef pj_thread_t *_obj
    cdef long _thread_desc[PJ_THREAD_DESC_SIZE]

cdef class PJSIPUA(object):
    # attributes
    cdef object _threads
    cdef object _event_handler
    cdef list _timers
    cdef PJLIB _pjlib
    cdef PJCachingPool _caching_pool
    cdef PJSIPEndpoint _pjsip_endpoint
    cdef PJMEDIAEndpoint _pjmedia_endpoint
    cdef pjsip_module _module
    cdef PJSTR _module_name
    cdef pjsip_module _opus_fix_module
    cdef PJSTR _opus_fix_module_name
    cdef pjsip_module _trace_module
    cdef PJSTR _trace_module_name
    cdef pjsip_module _ua_tag_module
    cdef PJSTR _ua_tag_module_name
    cdef pjsip_module _event_module
    cdef PJSTR _event_module_name
    cdef int _trace_sip
    cdef int _detect_sip_loops
    cdef int _enable_colorbar_device
    cdef PJSTR _user_agent
    cdef object _events
    cdef object _sent_messages
    cdef object _ip_address
    cdef int _rtp_port_start
    cdef int _rtp_port_count
    cdef int _rtp_port_usable_count
    cdef int _rtp_port_index
    cdef pj_stun_config _stun_cfg
    cdef int _fatal_error
    cdef set _incoming_events
    cdef set _incoming_requests
    cdef pj_rwmutex_t *audio_change_rwlock
    cdef pj_mutex_t *video_lock
    cdef list old_devices
    cdef list old_video_devices
    cdef object _zrtp_cache

    # private methods
    cdef object _get_sound_devices(self, int is_output)
    cdef object _get_default_sound_device(self, int is_output)
    cdef object _get_video_devices(self)
    cdef object _get_default_video_device(self)
    cdef int _poll_log(self) except -1
    cdef int _handle_exception(self, int is_fatal) except -1
    cdef int _check_self(self) except -1
    cdef int _check_thread(self) except -1
    cdef int _add_timer(self, Timer timer) except -1
    cdef int _remove_timer(self, Timer timer) except -1
    cdef int _cb_rx_request(self, pjsip_rx_data *rdata) except 0

    cdef pj_pool_t* create_memory_pool(self, bytes name, int initial_size, int resize_size)
    cdef void release_memory_pool(self, pj_pool_t* pool)
    cdef void reset_memory_pool(self, pj_pool_t* pool)

cdef int _PJSIPUA_cb_rx_request(pjsip_rx_data *rdata) with gil
cdef void _cb_detect_nat_type(void *user_data, pj_stun_nat_detect_result_ptr_const res) with gil
cdef int _cb_opus_fix_tx(pjsip_tx_data *tdata) with gil
cdef int _cb_trace_rx(pjsip_rx_data *rdata) with gil
cdef int _cb_trace_tx(pjsip_tx_data *tdata) with gil
cdef int _cb_add_user_agent_hdr(pjsip_tx_data *tdata) with gil
cdef int _cb_add_server_hdr(pjsip_tx_data *tdata) with gil
cdef PJSIPUA _get_ua()
cdef int deallocate_weakref(object weak_ref, object timer) except -1 with gil

# globals

cdef PJSTR _event_hdr_name
