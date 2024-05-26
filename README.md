# Repository Collection <br />SwiftUI & Clean Architecture & MVVM
![repository_collection](https://github.com/thien-codev/repository-collection/assets/65584893/d5f5117d-e803-4c92-b9db-3f16e2591386)

## Installation
To install the application, follow these steps:
1. Clone the repository: https://github.com/thien-codev/repository-collection
2. Navigate to the project: "cd repository-collection"
3. Open the project
4. Build 

## Layers
* **Domain Layer** = Entities + Use Cases + Repositories Interfaces
* **Data Repositories Layer** = Repositories Implementations + APIEndpoint + Persistence DB
* **Presentation Layer (MVVM)** = ViewModels + Views
 
## Includes
* SwiftUI
* Pagination
* Unit Tests (not yet)
* UI Tests (not yet)

## Infrastructure
Infrastructure contains networking interface and default network service using Alamofire. You can create your own network service.

## How to use app
Input a valid userId of Github to get list of his/her repositories. The network will request the github api. If getting successful responses, they will be stored persistently.

## Requirements
* Xcode Version 15.0+  Swift 5.0+

## **Note:** **Domain Layer** should not include anything from other layers




