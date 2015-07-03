<master src="../www/etp-master">
<property name="doc(title)">@pa.title;literal@</property>
<property name="context">@pa.context;literal@</property>

<if @pa.subtitle@ not nil>
<blockquote><b>@pa.subtitle@</b></blockquote>
</if>
<else>
<p>
</else>

<b>

<if @pa.location@ not nil>
@pa.location@ - 
</if>

@pa.release_date@ - 

</b>

@pa.content;noquote@

<p>