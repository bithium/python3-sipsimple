# cython: language_level=3

from ._pjsip cimport (
    pj_mutex_t,
    pj_pool_t,
    pjmedia_event,
    pjmedia_port,
    pjmedia_vid_dev_stream,
    pjmedia_vid_port,
    pjmedia_vid_stream,
)

cdef class VideoFrame(object):
    cdef readonly object data
    cdef readonly int width
    cdef readonly int height

cdef class VideoConsumer(object):
    cdef pjmedia_port *consumer_port
    cdef pjmedia_vid_port *_video_port
    cdef pj_pool_t *_pool
    cdef pj_mutex_t *_lock
    cdef int _running
    cdef int _closed
    cdef VideoProducer _producer
    cdef object __weakref__
    cdef object weakref

    cdef void _set_producer(self, VideoProducer producer)

cdef class VideoProducer(object):
    cdef pjmedia_port *producer_port
    cdef pjmedia_vid_port *_video_port
    cdef pj_pool_t *_pool
    cdef pj_mutex_t *_lock
    cdef int _running
    cdef int _started
    cdef int _closed
    cdef object _consumers

    cdef void _add_consumer(self, VideoConsumer consumer)
    cdef void _remove_consumer(self, VideoConsumer consumer)

cdef class VideoCamera(VideoProducer):
    cdef pjmedia_port *_video_tee
    cdef readonly unicode name
    cdef readonly unicode real_name

    cdef void _start(self)
    cdef void _stop(self)

cdef class FrameBufferVideoRenderer(VideoConsumer):
    cdef pjmedia_vid_dev_stream *_video_stream
    cdef object _frame_handler

    cdef _initialize(self, VideoProducer producer)
    cdef void _destroy_video_port(self)
    cdef void _start(self)
    cdef void _stop(self)

cdef class LocalVideoStream(VideoConsumer):
    cdef void _initialize(self, pjmedia_port *media_port)

cdef class RemoteVideoStream(VideoProducer):
    cdef pjmedia_vid_stream *_video_stream
    cdef object _event_handler

    cdef void _initialize(self, pjmedia_vid_stream *stream)

cdef LocalVideoStream_create(pjmedia_vid_stream *stream)
cdef RemoteVideoStream_create(pjmedia_vid_stream *stream, format_change_handler=*)
cdef int RemoteVideoStream_on_event(pjmedia_event *event, void *user_data) with gil
cdef void _start_video_port(pjmedia_vid_port *port)
cdef void _stop_video_port(pjmedia_vid_port *port)
