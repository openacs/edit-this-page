<master src="etp-master">
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<multiple name="all_pages">
e@all_pages.indent;noquote@
<if @all_pages.item_id@ eq @target_id@>
<em>@all_pages.title@</em><br>
</if>
<else>
<a href="etp-symlink?item_id=@item_id@&amp;target_id=@all_pages.item_id@">@all_pages.title@</a><br>
</else>
</multiple>

<p>
