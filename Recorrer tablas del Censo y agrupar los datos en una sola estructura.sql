select top 10 * from hogar_h35 WHERE Codigo = '01090101101001'

select top 25 * from CensoCompleto where variable = 'h35' and entidad = 'hogar' AND CodigoUbicacion = '01090101101001'

--	truncate table Respuestas
--	create table Respuestas (Entidad varchar(250), Variable varchar(150), CodigoUbicacion varchar(200), Respuesta varchar(300), Cantidad float)
declare	@Entidad varchar(100),
		@Tabla varchar(100),
		@Variable varchar(100),
		@Columna varchar(100),
		@qry varchar(max)

declare cr cursor for
	select	table_name as Tabla,
			replace(substring(table_name, 1, charindex('_', table_name)), '_', '') as Entidad,
			substring(table_name, charindex('_', table_name) + 1, 100) as Variable,
			column_name as Columna
	from information_schema.columns c
	where column_name not in ('barrio_o_paraje_de_residencia', 'total')
	  and table_name not in ('diccionario','ubigeo')
	  and table_name like 'hogar%'

open cr
fetch next from cr into @Tabla, @Entidad, @Variable, @Columna

while @@fetch_status = 0
begin
	if @Columna != 'Codigo'
		begin
			set @qry = 'insert into Respuestas (Entidad, Variable, CodigoUbicacion, Respuesta, Cantidad) 
						select ' + quotename(@Entidad, '''') + ',' + quotename(@Variable, '''') + ', Codigo, ' + 
						quotename(@Columna, '''')  + ', ' + @Columna
		  				+ ' from ' + @Tabla 
			--print @qry
			exec(@qry)			
		end
	fetch next from cr into @Tabla, @Entidad, @Variable, @Columna
end
close cr
deallocate cr
	