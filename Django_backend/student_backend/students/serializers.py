from rest_framework import serializers
from datetime import datetime
from .models import Student, Internship, Project, Opportunity

class InternshipSerializer(serializers.ModelSerializer):
    class Meta:
        model = Internship
        fields = '__all__'
    def to_internal_value(self, data):
        # Convert ISO 8601 datetime to just date
        data = data.copy()
        for date_field in ['start_date', 'end_date']:
            if date_field in data and isinstance(data[date_field], str):
                try:
                    # Handles cases like "2025-03-01T00:00:00.000"
                    data[date_field] = datetime.fromisoformat(data[date_field]).date()
                except ValueError:
                    raise serializers.ValidationError({date_field: 'Invalid date format'})
        return super().to_internal_value(data)    


class ProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = '__all__'

class StudentSerializer(serializers.ModelSerializer):
    internships = InternshipSerializer(many=True, read_only=True)
    projects = ProjectSerializer(many=True, read_only=True)
    class Meta:
        model = Student
        fields = '__all__'        

class OpportunitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Opportunity
        fields = '__all__'        