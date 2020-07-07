import json
from nameko.web.handlers import http

from buzzer import dependencies


class BuzzerService:
    name = 'buzzer'

    rmq = dependencies.Broker()

    '''
    POST /buzzer
    Body: { 'turn_on': boolean, 'duration': float|int }
    '''
    @http('POST', '/buzzer')
    def do_post(self, request):
        body = json.loads(request.get_data(as_text=True) or 'null')
        if body is None:
            return 400, 'Please provide a valid body'

        if ('turn_on' in body and
            'duration' in body and
                isinstance(body['duration'], (int, float))):
            self.rmq.publish(body)
            return 200, ""
        else:
            return (400, "Request body is not in correct format. Body: {}"
                    .format(str(body)))
