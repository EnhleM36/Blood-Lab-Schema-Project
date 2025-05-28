🩸 Blood Pathology Lab Database Schema
This project is a Blood Bank Database Schema designed as part of my learning journey in the Power Learn Project Academy's Software Development Program. It showcases how I’m applying database design principles to solve real-world problems in healthcare data management.

📘 Overview
The Blood Bank Schema models the core components and workflows involved in managing blood samples amd test, including:

Doctors issuing test requests

Patients and their health data

Sample collection, storage, and processing

Lab staff roles and responsibilities

Audit logs for traceability

Abnormal result alerts

Sample tracking using barcodes or QR codes

🛠️ Technologies Used
MySQL – Database schema design and relationships and  ERD visualization 

📂 Schema Highlights
The schema includes the following tables:

doctors – Stores doctor information

patients – Stores patient data

test_orders – Links doctors, patients, and requested tests

samples – Tracks blood samples with timestamps and statuses

lab_staff – Information on lab technicians and their roles

results – Stores test results, flags abnormalities

storage_locations – Details on where samples are stored

audit_logs – Keeps a record of actions for accountability

🚀 Purpose and Learning Goals
This project is part of my portfolio as I learn software development through the Power Learn Project Academy. I'm particularly interested in how data is structured and used in healthcare systems. By building this schema, I gained experience in:

Database normalization

Entity-relationship modeling

Designing for real-world data workflows

Thinking through access and audit control

🧠 What I’m Still Learning
I'm still actively learning about:

Query optimization

Advanced SQL (e.g., stored procedures, triggers)

Integrating backends with databases

Data visualization and analytics

💡 Future Improvements
Build a simple frontend UI to interact with the schema

Add user authentication for lab staff and doctors

Integrate notification system for abnormal results

Explore migrating to PostgreSQL for advanced features

🤝 Acknowledgements
Thanks to the Power Learn Project Academy for the support, mentorship, and learning resources that made this project possible.

