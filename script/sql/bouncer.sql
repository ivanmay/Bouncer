CREATE SCHEMA bouncer;

ALTER SCHEMA bouncer OWNER TO bouncer;

CREATE TABLE bouncer.email (
	id SERIAL PRIMARY KEY,
	email VARCHAR(255) NOT NULL
);

CREATE TYPE bouncer.enum_entity_type AS enum ('USER', 'SERVICE')

CREATE TABLE bouncer.entity (
	id SERIAL PRIMARY KEY,
	primary_login INT NOT NULL UNIQUE REFERENCES bouncer.email(id)
	entity_type bouncer.enum_entity_type NOT NULL
);

CREATE TABLE bouncer.service (
	id SERIAL PRIMARY KEY,
	service_name varchar(255) NOT NULL,
	primary_login INT NOT NULL UNIQUE REFERENCES bouncer.email(id)
)

CREATE TABLE bouncer.password (
	id SERIAL PRIMARY KEY,
	user_id int NOT NULL REFERENCES users(id),
	password varchar(255)
);

CREATE TABLE bouncer.user_mail_addresses (
	id SERIAL PRIMARY KEY,
	user_id int REFERENCES bouncer.users(id),
	email_id int REFERENCES bouncer.email(id),
	UNIQUE(user_id, email_id)
);

CREATE TABLE bouncer.roles (
	id SERIAL PRIMARY KEY,
	role_name varchar(255) NOT NULL UNIQUE
);

CREATE TABLE bouncer.entity_roles (
	id SERIAL PRIMARY KEY,
	entity_id int NOT NULL REFERENCES users(id),
	role_id int NOT NULL REFERENCES roles(id)
);

CREATE TABLE bouncer.role_hierarchy (
	id SERIAL PRIMARY KEY,
	parent_id int4 NOT NULL REFERENCES bouncer.roles (id),
	child_id int4 NOT NULL REFERENCES bouncer.roles (id)
);


