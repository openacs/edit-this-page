<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="etp::make_content_type.object_type_create">      
<querytext>
	begin
	    acs_object_type.create_type (
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
	    );
	end;
</querytext>
</fullquery>

<fullquery name="etp::make_content_type.attribute_create">      
<querytext>
	begin
		:1 := acs_attribute.create_attribute (
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
		);
	end;
</querytext>
</fullquery>
 
<fullquery name="etp::make_page.page_create">
<querytext>
	begin
	etp_create_page(
	  :package_id,
	  :name,
          :title,
	  :content_type
	);
	end;
</querytext>
</fullquery>

<fullquery name="etp::register-page.package_id_from_url">      
<querytext>
	    select object_id as package_id
	      from site_nodes
	     where node_id = site_node.node_id(:url_stub, null)
</querytext>
</fullquery>
 
</queryset>
