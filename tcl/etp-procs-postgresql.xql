<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="etp::define_content_type.object_type_create">      
<querytext>
	    select acs_object_type__create_type (
	        :content_type,
	        :pretty_name,
	        :pretty_plural,
	        'content_revision',
	        :content_type,
	        :content_type,
	        null,
	        'f',
	        null,
	        null
	    )
</querytext>
</fullquery>

<fullquery name="etp::define_content_type.attribute_create">      
<querytext>
		select acs_attribute__create_attribute (
		    :content_type,
		    :a_name,
		    :a_datatype,
		    :a_pretty_name,
		    :a_pretty_plural,
		    null,
		    null,
		    :a_default,
		    1,
		    1,
		    null,
		    'generic',
		    'f'
		)
</querytext>
</fullquery>

<fullquery name="etp::make_page.page_create">      
<querytext>
	select etp_create_page(
	  :package_id,
	  :name,
          :title,
	  :content_type
	)
</querytext>
</fullquery>

<fullquery name="etp::register_page.package_id_from_url">      
<querytext>
	    select object_id as package_id
	      from site_nodes
	     where node_id = site_node__node_id(:url_stub, null)
</querytext>
</fullquery>

</queryset>
