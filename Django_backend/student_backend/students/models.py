from django.db import models
from django.core.exceptions import ValidationError
from django.utils.text import slugify


# File size validator (5 MB max)
def validate_file_size(value):
    limit = 5 * 1024 * 1024  # 5 MB
    if value.size > limit:
        raise ValidationError('File too large. Size should not exceed 5 MB.')


class Student(models.Model):
    name = models.CharField(max_length=100)
    roll = models.CharField(max_length=20, unique=True)
    email = models.EmailField(unique=True)

    DEPARTMENT_CHOICES = [
        ('AIDS', 'AI & Data Science'),
        ('AIML', 'AI & Machine Learning'),
        ('CSE', 'Computer Science'),
        ('VLSI', 'Electrical Engineering'),
        ('IIOT', 'Internet of Things'),
        ('CSE-CS', 'Computer Science - Cyber Security'),
        ('CSE-AM', 'Computer Science - Applied Maths'),
    ]
    department = models.CharField(max_length=100, choices=DEPARTMENT_CHOICES)

    YEAR_CHOICES = [
        ('1st', '1st Year'),
        ('2nd', '2nd Year'),
        ('3rd', '3rd Year'),
        ('4th', '4th Year'),
    ]
    year = models.CharField(max_length=3, choices=YEAR_CHOICES)

    # created_at = models.DateTimeField(auto_now_add=True)
    # updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.name} ({self.roll})"


class Internship(models.Model):
    student = models.ForeignKey(Student, related_name='internships', on_delete=models.CASCADE)
    company_name = models.CharField(max_length=100)
    position = models.CharField(max_length=100)
    duration = models.CharField(max_length=50)
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)
    certificate = models.FileField(upload_to='certificates/', validators=[validate_file_size], null=True, blank=True)
    description = models.TextField(blank=True)

    # created_at = models.DateTimeField(auto_now_add=True)
    # updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.student.name} - {self.company_name}"


class Project(models.Model):
    student = models.ForeignKey(Student, related_name='projects', on_delete=models.CASCADE)
    title = models.CharField(max_length=100)
    description = models.TextField()
    github_link = models.URLField(blank=True, null=True)
    submission_file = models.FileField(upload_to='projects/', validators=[validate_file_size], null=True, blank=True)

    # created_at = models.DateTimeField(auto_now_add=True)
    # updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.student.name} - {self.title}"


class Opportunity(models.Model):
    TYPE_CHOICES = [
        ('Internship', 'Internship'),
        ('Placement', 'Placement'),
    ]

    title = models.CharField(max_length=200)
    description = models.TextField()
    company_name = models.CharField(max_length=100)
    opportunity_type = models.CharField(max_length=20, choices=TYPE_CHOICES)
    deadline = models.DateField()
    # created_at = models.DateTimeField(auto_now_add=True)
    slug = models.SlugField(unique=True, blank=True)

    class Meta:
        ordering = ['deadline']

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.title} - {self.company_name}"
