<?xml version="1.0"?>
<queryset>

<fullquery name="get_content_pages">
<querytext>
  select name, title, tree_sortkey as sort_order
    from cr_items i, cr_revisions r
   where i.parent_id = etp_get_folder_id(:package_id)
     and i.name != 'index'
     and i.item_id = r.item_id
     and i.latest_revision = r.revision_id
   order by tree_sortkey
</querytext>
</fullquery>

</queryset>
