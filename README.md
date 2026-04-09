# Inventory Management App with Firestore

Real-time Flutter inventory app that performs CRUD operations on Cloud Firestore and keeps UI synchronized using streams.

## Assignment Coverage

- Firebase connected in main with Firebase.initializeApp.
- Inventory model includes toMap and fromMap.
- Firestore service supports add, stream, update, and delete.
- UI uses StreamBuilder with ListView.builder.
- Form validation covers empty fields, numeric parsing, and invalid values.
- Enhanced features documented below.

## Tech Stack

- Flutter and Dart
- firebase_core
- cloud_firestore

## Architecture (Clean Layers)

- Domain
	- Inventory entity
	- Repository contract
- Data
	- Firestore service for direct cloud operations
	- Repository implementation that maps models to domain entities
	- InventoryItemModel with fromMap and toMap
- Presentation
	- InventoryPage with StreamBuilder and CRUD UI
	- Form dialog with validator-based input checks



Included tests:
- Validator tests for required, numeric, and invalid inputs
- Model mapping test for toMap and fromMap
- Existing habit metrics tests retained from previous module

## Reflection

See REFLECTION.md for the required reflection answers document.

## Submission Checklist

- Public GitHub repository URL
- New commit history for this assignment only
- README with enhanced features listed
- APK artifact included
- Reflection document included
