<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="etp::revision_url.package_url">
    <querytext>
select site_node__url(node_id) as package_url from site_nodes where object_id = (select package_id from cr_folders where folder_id= (select parent_id from cr_items where latest_revision = :object_id))
    </querytext>
</fullquery>

<fullquery name="etp::create_search_impl.create_search_impl">
    <querytext>
	select acs_sc_impl__new(
		'FtsContentProvider',		-- impl_contract_name
		:content_type,			-- impl_name
		'edit-this-page'			-- impl_owner.name
	);
    </querytext>
</fullquery>

<fullquery name="etp::create_search_impl.create_datasource_alias">
    <querytext>
	select acs_sc_impl_alias__new(
		'FtsContentProvider',		-- impl_contract_name
		:content_type,			-- impl_name
		'datasource',			-- impl_operation_name
		'etp_page_revision__datasource',	-- impl_alias
		'TCL'				-- impl_pl
	)
    </querytext>
</fullquery>

<fullquery name="etp::create_search_impl.create_url_alias">
    <querytext>
	select acs_sc_impl_alias__new(
		'FtsContentProvider',		-- impl_contract_name
		:content_type,		-- impl_name
		'url',				-- impl_operation_name
		'etp_page_revision__url',	-- impl_alias
		'TCL'				-- impl_pl
	);
   </querytext>
</fullquery>

<fullquery name="etp::create_search_impl.install_binding">
    <querytext>
	select acs_sc_binding__new(
		'FtsContentProvider', 	-- contract_name
		:content_type		-- impl_name
	);
    </querytext>
</fullquery>

</queryset>