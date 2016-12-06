--Enums
CREATE extension ltree;

CREATE SCHEMA praetorian;

CREATE TYPE praetorian.enum_account_state AS enum ('ENABLED', 'DISABLED', 'LOCKED');
CREATE TYPE praetorian.enum_user_priority AS enum ('PRIMARY', 'SECONDARY', 'OTHER');
CREATE TYPE praetorian.enum_auth_actions AS enum ('RESET', 'DISABLE', 'DELETE', 'EXPIRED');
CREATE TYPE praetorian.enum_role_state AS enum ('REMOVED', 'ADDED');

CREATE TABLE praetorian.users (
	id serial PRIMARY KEY,
	first_name varchar(120) NOT NULL,
	last_name varchar(120) NOT NULL
);

CREATE TABLE praetorian.user_logs (
	id serial PRIMARY KEY,
	state praetorian.enum_account_state NOT NULL,
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	log_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,	
	UNIQUE (state, user_id, log_time)
);

CREATE TABLE praetorian.user_mail_addresses (
	id serial PRIMARY KEY,
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	mail_address varchar(255) NOT NULL,
	priority praetorian.enum_user_priority NOT NULL
);

CREATE TABLE praetorian.user_contact_numbers (
	id serial PRIMARY KEY,
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	contact_number varchar(30) NOT NULL,
	priority praetorian.enum_user_priority NOT NULL
);

CREATE TABLE praetorian.auth_user_basic (
	id serial PRIMARY KEY,
	user_id int4 NOT NULL UNIQUE REFERENCES praetorian.users(id),
	password UUID NOT NULL,
	expire TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	reset BOOLEAN NOT NULL
);

CREATE TABLE praetorian.auth_user_basic_logs (
	id serial PRIMARY KEY,
	auth_user_basic_id int4 NOT NULL REFERENCES praetorian.auth_user_basic(id),
	auth_action praetorian.enum_auth_actions NOT NULL,
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	log_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,	
	UNIQUE (auth_user_basic_id, auth_action, user_id, log_time)
);

CREATE TABLE praetorian.services (
	id serial PRIMARY KEY,
	name varchar(100) UNIQUE NOT NULL,
	description varchar(255) NOT NULL
);

CREATE TABLE praetorian.service_logs (
	id serial PRIMARY KEY,
	service_id int4 NOT NULL REFERENCES praetorian.services(id),
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	state praetorian.enum_account_state NOT NULL,
	log_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (service_id, user_id, state, log_time)
);

CREATE TABLE praetorian.auth_service_account (
	id serial PRIMARY KEY,
	service_id int4 NOT NULL UNIQUE REFERENCES praetorian.services(id),
	service_key UUID NOT NULL, 
	secret UUID NOT NULL
);

CREATE TABLE praetorian.auth_service_account_logs(
	id serial PRIMARY KEY,
	auth_service_account_id int4 NOT NULL REFERENCES praetorian.auth_service_account(id),
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	state praetorian.enum_account_state NOT NULL,
	log_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (auth_service_account_id, user_id, state, log_time)
);

CREATE TABLE praetorian.roles (
	id serial PRIMARY KEY,
	role_name VARCHAR (100),
	description varchar(255)
);

CREATE TABLE praetorian.role_trees (
	id serial PRIMARY KEY,
	role_id int4 NOT NULL REFERENCES roles(id),
	node ltree NOT NULL
);

CREATE TABLE praetorian.role_tree_logs(
	id serial PRIMARY KEY,
	role_id int4 NOT NULL REFERENCES praetorian.role_trees(id),
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	state praetorian.enum_role_state NOT NULL,
	log_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (role_id, user_id, state, log_time)
);

CREATE TABLE praetorian.user_roles (
	id serial PRIMARY KEY,
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	role_id int4 NOT NULL REFERENCES praetorian.role_trees(id),
	UNIQUE (user_id, role_id)
);

CREATE TABLE praetorian.user_role_logs(
	id serial PRIMARY KEY,
	user_roles_id int4 NOT NULL REFERENCES praetorian.user_roles(id),
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	state praetorian.enum_role_state NOT NULL,
	log_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (user_roles_id, user_id, state, log_time)
);

CREATE TABLE praetorian.service_roles (
	id serial PRIMARY KEY,
	service_id int4 NOT NULL REFERENCES praetorian.services(id),
	role_id int4 NOT NULL REFERENCES praetorian.role_trees(id),
	UNIQUE (service_id, role_id)
);

CREATE TABLE praetorian.service_role_logs(
	id serial PRIMARY KEY,
	service_roles_id int4 NOT NULL REFERENCES praetorian.service_roles(id),
	user_id int4 NOT NULL REFERENCES praetorian.users(id),
	state praetorian.enum_role_state NOT NULL,
	log_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (service_roles_id, user_id, state, log_time)
);