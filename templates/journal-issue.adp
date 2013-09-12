<master src="../www/etp-master">
<property name="doc(title)">@pa.title;noquote@</property>
<property name="context">@pa.context;noquote@</property>

<if @pa.content@ not nil>
@pa.content;noquote@
</if>

<p>

<multiple name="content_items">
<b>@content_items.section@</b>
<blockquote>
<group column="section">
<a href="@content_items.name@">@content_items.title@</a><br>
<i>@content_items.byline@</i>
<br>
</group>
</blockquote>
<p>
</multiple>
