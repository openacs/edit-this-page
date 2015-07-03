<master src="/packages/edit-this-page/www/etp-master">
<property name="doc(title)">@pa.title;literal@</property>
<property name="context">@pa.context;literal@</property>

<p>

<if @pa.content@ not nil>
@pa.content;noquote@
<p>
</if>

Frequently Asked Questions:
<ol>
<multiple name="content_items">
<li>
<a href="#@content_items.rownum@">@content_items.title@</a>
</li>
</multiple>
</ol>
<hr>
<p>

Questions and Answers:
<ol>
<multiple name="content_items">
<a name="@content_items.rownum@"></a>
<li>
<b>Q:</b> <em>@content_items.title@</em>
<p>
<b>A:</b> 
@content_items.content;noquote@
<p>
</li>
</multiple>
</ol>
