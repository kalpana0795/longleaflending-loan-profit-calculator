# README

* Ruby Version 3.2.4

* Rails Version 7.1.3

#### System Dependencies

* Install `ruby-3.2.4`
* Install gem `foreman`
* Install `redis-6+`

#### Instructions

* Clone the git repository and navigate to the application folder.
* Install ruby-3.2.4
* Run the command `bundle install`
* Run the test suite using `rspec` to confirm if the setup is successful.
* Start the rails server, tailwind build and sidekiq using `bin/dev`
* Visit `http://localhost:3000/` to test the functionality
* Visit `http://localhost:3000/sidekiq` to check the background jobs status
* Visit `http://localhost:3000/letter_opener` to check the Profit Termsheet emails

#### Thought Process and Design Decisions

In designing this application, I prioritized a clear separation of concerns and user experience. Service objects encapsulate business logic, ensuring controllers remain focused on request handling. Active Jobs handle background tasks like PDF generation and email sending, enhancing performance and user experience. Hotwire and Stimulus were chosen to create a dynamic, responsive multi-step form, providing immediate feedback and reducing user overwhelm.


#### Ensuring Security and Scalability

To ensure security, I implemented client-side validations and utilized strong parameters to prevent mass assignment. As a future enhancement we can add more server side validations.

For scalability, background jobs offload time-consuming tasks like generating the termsheet pdf and sending email, improving performance under high load.

#### Future Enhancements

* Database can be integrated to store the user details and use for further communications like sending weekly newsletters.
* Authentication and authorization can be implemented for better security.
* More server side validations can be added to ensure the validity of form data.
* Error notifiers can be integrated as well as error classes can be introduced.
