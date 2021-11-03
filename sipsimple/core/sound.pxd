# cython: language_level=3

from ._pjsip cimport (
    pj_mutex_t,
    pj_pool_t,
    pjmedia_conf,
    pjmedia_master_port,
    pjmedia_port,
    pjmedia_snd_port,
)

from .ua cimport PJSIPUA, Timer


cdef class AudioMixer(object):
    # attributes
    cdef int _input_volume
    cdef int _output_volume
    cdef bint _muted
    cdef pj_mutex_t *_lock
    cdef pj_pool_t *_conf_pool
    cdef pj_pool_t *_snd_pool
    cdef pjmedia_conf *_obj
    cdef pjmedia_master_port *_master_port
    cdef pjmedia_port *_null_port
    cdef pjmedia_snd_port *_snd
    cdef list _connected_slots
    cdef readonly int ec_tail_length
    cdef readonly int sample_rate
    cdef readonly int slot_count
    cdef readonly int used_slot_count
    cdef readonly unicode input_device
    cdef readonly unicode output_device
    cdef readonly unicode real_input_device
    cdef readonly unicode real_output_device

    # private methods
    cdef void _start_sound_device(self, PJSIPUA ua, unicode input_device, unicode output_device, int ec_tail_length)
    cdef void _stop_sound_device(self, PJSIPUA ua)
    cdef int _add_port(self, PJSIPUA ua, pj_pool_t *pool, pjmedia_port *port) except -1 with gil
    cdef int _remove_port(self, PJSIPUA ua, unsigned int slot) except -1 with gil
    cdef int _cb_postpoll_stop_sound(self, timer) except -1

cdef class ToneGenerator(object):
    # attributes
    cdef int _slot
    cdef int _volume
    cdef pj_mutex_t *_lock
    cdef pj_pool_t *_pool
    cdef pjmedia_port *_obj
    cdef Timer _timer
    cdef readonly AudioMixer mixer

    # private methods
    cdef PJSIPUA _get_ua(self, int raise_exception)
    cdef int _stop(self, PJSIPUA ua) except -1
    cdef int _cb_check_done(self, timer) except -1

cdef class RecordingWaveFile(object):
    # attributes
    cdef int _slot
    cdef int _was_started
    cdef pj_mutex_t *_lock
    cdef pj_pool_t *_pool
    cdef pjmedia_port *_port
    cdef readonly object filename
    cdef readonly AudioMixer mixer

    # private methods
    cdef PJSIPUA _check_ua(self)
    cdef int _stop(self, PJSIPUA ua) except -1

cdef class WaveFile(object):
    # attributes
    cdef object __weakref__
    cdef object weakref
    cdef int _slot
    cdef int _volume
    cdef pj_mutex_t *_lock
    cdef pj_pool_t *_pool
    cdef pjmedia_port *_port
    cdef readonly object filename
    cdef readonly AudioMixer mixer

    # private methods
    cdef PJSIPUA _check_ua(self)
    cdef int _stop(self, PJSIPUA ua, int notify) except -1
    cdef int _cb_eof(self, timer) except -1

cdef class MixerPort(object):
    cdef int _slot
    cdef int _was_started
    cdef pj_mutex_t *_lock
    cdef pj_pool_t *_pool
    cdef pjmedia_port *_port
    cdef readonly AudioMixer mixer

    # private methods
    cdef PJSIPUA _check_ua(self)
    cdef int _stop(self, PJSIPUA ua) except -1

cdef int _AudioMixer_dealloc_handler(object obj) except -1
cdef int cb_play_wav_eof(pjmedia_port *port, void *user_data) with gil
