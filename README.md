# Automated Canteen Ordering System

Welcome to the Automated Canteen Ordering System project! This web application streamlines the process of ordering food online for employees within a shared office space.

## Project Overview

The purpose of this application is to provide a convenient way for employees and external users to order food from common canteens within an office building. The system includes different user roles, such as Admin, Employees, and Canteen Chefs, each with specific functionalities.

## Features

### Admin Panel
- Create and manage companies within the office premises.
- Manage food stores, including Google Map location.
- Approve or reject employee access.
- Approve or reject chef access.
- Show or hide order notifications.
- Create order status (Received, Preparing/Cooking, Finished, Delivered).
- Add food categories (e.g., North-Indian, Chinese, South-Indian, Continental).
- Set priority for user ordering processes.

### Employee User Dashboard
- Notifications for order status changes and approval.
- Internal communication board with chefs.
- Profile completion with associated company selection.
- Order food with filtration options (food store, food category).
- Order history with details like date, ordered items, and prices.
- Elastic Search functionality for food search.

### Chef User Dashboard
- Notifications and email updates for order status changes.
- Internal communication board with employees.
- Profile completion with associated food store selection.
- Add food menus available for preparation.
- View received orders with details.
- Upload and showcase food images in the gallery.

## How to Use

1. Clone the repository to your local machine:
   ```
    https://github.com/sangita-kreeti/Automated-Canteen-Ordering-System.git
   ```

## Application Versions
* Rails -> 6.1.7.3
* Ruby -> 3.0.2
* Node -> 16.20.2
* Yarn -> 1.22.19
* NPM -> 8.19.4
* Elastic Search -> 7.2.1

2. Install dependencies:
   ```
   bundle install
   ```
3. Set up the database
   ```
   rails db:create db:migrate
   ```
4. Start the Rails server:
   ```
   rails server   
   ```
5. Access the application in your web browser at http://localhost:3000.
6. Tech Stack
     * Ruby on Rails 6
      * HTML, CSS
        * JavaScript
      *  Elastic Search
        * oogle Authentication
        * Google Map implementation
        * Action Cable


Happy coding! 🍔🚀
