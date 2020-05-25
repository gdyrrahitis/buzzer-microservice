from nameko.web.handlers import http

from buzzer import dependencies


class BuzzerService:
    name = "buzzer"

    rmq = dependencies.Broker()

    @http('POST', '/buzzer')
    def do_post(self, request):
        body = {'turn_on': True}
        self.rmq.publish(body)
        return 200, ""
