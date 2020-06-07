import rabbitpy
from nameko import config
from nameko.extensions import DependencyProvider


AMQP_URI_KEY = 'AMQP_URI'
ROUTING_KEY = 'pi_buzzer'


class BrokerWrapper:
    def __init__(self, channel, exchange):
        self.channel = channel
        self.exchange = exchange

    def publish(self, body):
        properties = {'content_type': 'application/json'}
        message = rabbitpy.Message(self.channel, body, properties)
        message.publish(self.exchange, ROUTING_KEY)


class Broker(DependencyProvider):
    def setup(self):
        connection = rabbitpy.Connection(config.get(AMQP_URI_KEY))
        self.channel = connection.channel()
        self.exchange = rabbitpy.Exchange(self.channel, 'exch_pi')
        self.exchange.declare()
        queue = rabbitpy.Queue(
            self.channel,
            'q_pi_buzzer',
            arguments={'x-message-ttl': 3600000})  # 1h

        queue.declare()
        queue.bind(self.exchange, ROUTING_KEY)

    def get_dependency(self, worker_context):
        return BrokerWrapper(self.channel, self.exchange)
