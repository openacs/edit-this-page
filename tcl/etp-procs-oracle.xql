<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="etp::define_content_type.object_type_create">      
<querytext>
	begin
	    acs_object_type.create_type (
	        object_type    => :content_type,
	        pretty_name    => :pretty_name,
	        pretty_plural  => :pretty_plural,
	        supertype      => 'content_revision',
	        table_name     => :content_type,
	        id_column      => :content_type
	    );
	end;
</querytext>
</fullquery>

<fullquery name="etp::define_content_type.attribute_create">      
<querytext>
	begin
		:1 := acs_attribute.create_attribute (
		    object_type      => :content_type,
		    attribute_name   => :a_name,
		    datatype         => :a_datatype,
		    pretty_name      => :a_pretty_name,
		    pretty_plural    => :a_pretty_plural,
		    default_value    => :a_default,
		    min_n_values     => 1,
		    max_n_values     => 1,
		    storage          => 'generic'
		);
	end;
</querytext>
</fullquery>
 
<fullquery name="etp::make_page.page_create">
<querytext>
	begin
	  :1 := etp.create_page(
	           package_id     => :package_id,
	           name           => :name,
                   title          => :title,
	           content_type   => :content_type
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

<fullquery name="etp::make_page.page_exists">      
<querytext>
	    select 1 from cr_items
	     where parent_id = etp.get_folder_id(:package_id)
	       and name = :name
</querytext>
</fullquery>

<fullquery name="etp::get_pa.get_page_attributes">      
<querytext>
	select i.item_id, i.name, r.revision_id, r.title, 
	       r.description, r.publish_date, r.content $extended_attributes
	  from cr_items i, cr_revisions r
	 where i.parent_id = etp.get_folder_id(:package_id)
	   and i.name = :name
	   and i.item_id = r.item_id
	   and r.revision_id = i.live_revision
</querytext>
</fullquery>
 
<fullquery name="etp::get_pa.get_page_attributes_other_revision">      
<querytext>
	select i.item_id, i.name, r.revision_id, r.title, 
	       r.description, r.publish_date, r.content $extended_attributes
	  from cr_items i, cr_revisions r
	 where i.parent_id = etp.get_folder_id(:package_id)
	   and i.name = :name
	   and i.item_id = r.item_id
	   and r.revision_id = :revision_id
</querytext>
</fullquery>

<fullquery name="etp::get_latest_revision_id.get_latest_revision_id">
<querytext>
	select max(revision_id) as revision_id
          from cr_revisions r, cr_items i
         where i.parent_id = etp.get_folder_id(:package_id)
           and i.name = :name
           and i.item_id = r.item_id
</querytext>
</fullquery>

<fullquery name="etp::get_live_revision_id.get_live_revision_id">
<querytext>
	select live_revision as revision_id
          from cr_items i
         where i.parent_id = etp.get_folder_id(:package_id)
           and i.name = :name
</querytext>
</fullquery>

<fullquery name="etp::get_content_items.get_content_items">
<querytext>
   select * from
     (select * from (
	select $columns
          from cr_items i, cr_revisions r
         where i.parent_id = etp.get_folder_id(:package_id)
	   and i.name != 'index'
           and i.live_revision = r.revision_id(+)
     ) attributes
     where $extra_where_clauses
     order by item_id)
   $limit_clause
</querytext>
</fullquery>


<fullquery name="etp::get_subtopics.get_subtopics">
<querytext>
select child.name, child.node_id, child.object_id as package_id,
                   etp.package_title(child.object_id) as title,
                   etp.package_description(child.object_id) as description
  from site_nodes parent, site_nodes child, apm_packages p
 where parent.object_id = :package_id
   and child.parent_id = parent.node_id
   and child.object_id = p.package_id
   and p.package_key = 'edit-this-page'
</querytext>
</fullquery>
 

<partialquery name="etp::get_attribute_lookup_sql.lookup_sql_clause">
  <querytext>
    etp.get_attribute_value(r.revision_id, $attribute_id)
  </querytext>
</partialquery>

<partialquery name="etp::get_content_items.gci_orderby">
  <querytext>
  </querytext>
</partialquery>

<partialquery name="etp::get_content_items.gci_columns_clause">
  <querytext>
   i.item_id, i.name,
             to_char(r.publish_date, 'Mon DD, YYYY') as publish_date, rownum as sort_order,
             (select object_type from acs_objects 
               where object_id = i.item_id) as object_type,
             etp.get_relative_url(i.item_id, i.name) as url,
             etp.get_title(i.item_id, r.title) as title,
             etp.get_description(i.item_id, r.description) as description
  </querytext>
</partialquery>


</queryset>
