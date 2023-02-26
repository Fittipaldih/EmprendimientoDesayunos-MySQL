EN ESPAÑOL: <br>
Para el emprendimiento culinario de pastelería "Desayunos a Domicilio” se ha plasmado el siguiente modelo relacional: 
Realizar la creacion de la Base de Datos y las consultas necesarias para el correcto funcionamiento del mismo. 
<br><br>
Producto (idProducto, Nombre, fecha_creacion, precio)   
Temas_Producidos (idTema, idProducto)   
Composición (idProducto, idComponente, vencimiento, cantidad_componente)   
Componente (idComponente, Descripción, idColorPredominante, esPersonalizado, costo)   
Receta (idComponente, paso, idIngrediente, medida, cantidad, elaboración)   
Ingrediente (idIngrediente, nombre)   
Tema (idTema, Nombre, color1, color2, color3)   
Color (idColor, Nombre)  



IN ENGLISH: <br>
For the culinary pastry enterprise "Desayunos a Domicilio" the following relational model has been embodied:
 Carry out the creation of the Database and the necessary consultations for the correct functioning. <br><br>
Product (idProducto, Name, date_creation, price)<br>
Themes_Produced (idTema, idProducto)<br>
Composition (idProducto, idComponente, expiration, quantity_component)<br>
Component (idComponent, Description, idPrevailingColor, isCustom, cost)<br>
Recipe (idComponent, step, idIngrediente, measure, amount, elaboration)<br>
Ingredient (idIngredient, name)<br>
Theme (idTheme, Name, color1, color2, color3)<br>
Color (idColor, Name)
