-- DaveB test service contracts for etp-page-revision
-- you will need a service contract implementation for
-- every ETP application that uses a different content type

select acs_sc_impl__new(
	'FtsContentProvider',		-- impl_contract_name
	'etp_page_revision',			-- impl_name
	'edit-this-page'			-- impl_owner.name
);

select acs_sc_impl_alias__new(
	'FtsContentProvider',		-- impl_contract_name
	'etp_page_revision',			-- impl_name
	'datasource',			-- impl_operation_name
	'etp::revision_datasource',	-- impl_alias
	'TCL'				-- impl_pl
);

select acs_sc_impl_alias__new(
	'FtsContentProvider',		-- impl_contract_name
	'etp_page_revision',			-- impl_name
	'url',				-- impl_operation_name
	'etp::revision_url',		-- impl_alias
	'TCL'				-- impl_pl
);

select acs_sc_binding__new (
	'FtsContentProvider',
	'etp_page_revision'
);
