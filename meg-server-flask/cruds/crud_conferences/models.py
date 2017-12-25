import datetime
from backend import db

class Conferences(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    acronym = db.Column(db.String(50))
    name = db.Column(db.String(50))
    city = db.Column(db.String(50))
    country = db.Column(db.String(50))
    venue = db.Column(db.String(50))
    start_date = db.Column(db.Date())    
    end_date = db.Column(db.Date())    

    def set_fields(self, fields):
        self.acronym = fields.get('acronym')
        self.name = fields.get('name')
        self.city = fields.get('city')
        self.country = fields.get('country')
        self.venue = fields.get('venue')
        self.start_date = datetime.datetime.strptime(fields.get('start_date'), "%d/%m/%Y").date() if fields.get('start_date') else None
        self.end_date = datetime.datetime.strptime(fields.get('end_date'), "%d/%m/%Y").date() if fields.get('end_date') else None                
        
    def serialize(self):
        return dict(id=self.id, acronym=self.acronym, name=self.name, 
                            city=self.city, country=self.country, venue=self.venue, 
                            start_date=self.start_date.strftime('%d/%m/%Y') if self.start_date else None, end_date=self.end_date.strftime('%d/%m/%Y') if self.end_date else None)
