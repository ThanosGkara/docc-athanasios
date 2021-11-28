import bottle
from bottle import request, response
from bottle import post
from config_reshape import flatten, new_vocab, filter_ranches
import json
import yaml

_names = set()                    # the set of names


@post('/transform')
def transform_handler():
    """
    Handles transformation
    """
    loaded = yaml.safe_load(request.body)
    flat = flatten(filter_ranches(loaded))
    clean_string = new_vocab(json.dumps(flat))

    response.content_type = "application/json"
    response.body = clean_string
    return response


def main():
    """ Prepares and launches the bottle app. """
    app = bottle.default_app()
    app.run(port=8000, host='0.0.0.0')


if __name__ == '__main__':
    main()
