# InvestorApp

## Chore

- 12-02-2025 - Basic investor form and file upload (1hr)
- 12-03-2025 - Validation, tests, documentation, cleanup (1hr)

## Completed Features
- Investor data form with validation (name, DOB, phone, address)
- US state dropdown with server-side validation
- 5-digit ZIP code validation (client + server)
- File upload with 3MB limit
- Docker development environment
- 15 passing tests (context + controller)


## Run locally

```
make build
```

or you can use docker-compose directly:
```
docker-compose up --build
```

Visit http://localhost:4001

## Run Tests

```
make test
```
or 
```
docker-compose exec -e MIX_ENV=test -e DB_HOST=db app mix test
``` 

## Future improvements (if I had more time)

### Authentication/Authorization

1. Run: mix phx.gen.auth Accounts User users
2. Run: mix ecto.migrate
3. Wrap routes in :require_authenticated_user pipeline in router.ex
4. Access current_user via conn.assigns.current_user
5. Optional: Add role field to User schema for admin/user roles


### Large File Support  (> 3 mb)
1. Add JavaScript XHR upload handler with progress events
2. Add progress bar HTML/CSS to form
3. Increase or remove server-side file size limit like i commented out in the controller
4. Consider chunked uploads for very large files (better if we have upload distination to s3 or azure blob storage)

### Duplicate Detection
1. Add SSN field to investor schema (encrypted field to not expose it)
2. Before create, query: Repo.get_by(Investor, ssn: ssn) or match on first_name + last_name
3. If match found, prompt user to update existing or create new
4. Add update_investor/2 function back to context

### Additional Features
1. SSN field with input masking and validation
2. File type validation (PDF, images only)
3. Admin dashboard to list/view/edit/delete investors
4. Email notifications on submission (if we want to go crazy we can have queue and schedule using Oban for background processing)
5. Audit logging for compliance
