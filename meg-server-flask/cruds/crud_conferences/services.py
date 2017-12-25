from flask import jsonify, Blueprint, request
from cruds.crud_conferences import models
from backend import db
import json

conferences = Blueprint("conference", __name__)

@conferences.route('/conferences', methods=['GET'])
def get_conferences():
    return json.dumps([conferences.serialize() for conferences in models.Conferences.query.all()]), 200

@conferences.route('/add_conferences', methods=['POST'])
def add_conferences():
    data = dict(request.get_json())

    conferences_obj = models.Conferences()
    conferences_obj.set_fields(data)
    db.session.add(conferences_obj)

    return jsonify(conferences_obj.serialize()), 200

@conferences.route('/update_conferences/<conferences_id>', methods=['POST'])
def update_conferences(conferences_id):
    data = dict(request.get_json())
    conferences_obj = models.Conferences.query.get(conferences_id)

    if conferences_obj:
        conferences_obj.set_fields(data)
        db.session.commit()
        return jsonify(conferences_obj.serialize()), 200

    return jsonify(result='invalid user id'), 404

@conferences.route('/delete_conferences/<conferences_id>', methods=['POST'])
def delete_conferences(conferences_id):
    conferences_obj = models.Conferences.query.get(conferences_id)
    if conferences_obj:
        db.session.delete(conferences_obj)
        db.session.commit()
        return jsonify(result=dict(message="Deleted conferences successfully")), 200
    return jsonify(result=dict(message='invalid conferences id')), 404
