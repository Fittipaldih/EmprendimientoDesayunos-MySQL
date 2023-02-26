ESPAÑOL:
Para el emprendimiento culinario de pastelería "Desayunos a Domicilio” se ha plasmado el siguiente modelo relacional: 
 
Producto (idProducto, Nombre, fecha_creacion, precio)   
Temas_Producidos (idTema, idProducto)   
Composición (idProducto, idComponente, vencimiento, cantidad_componente)   
Componente (idComponente, Descripción, idColorPredominante, esPersonalizado, costo)   
Receta (idComponente, paso, idIngrediente, medida, cantidad, elaboración)   
Ingrediente (idIngrediente, nombre)   
Tema (idTema, Nombre, color1, color2, color3)   
Color (idColor, Nombre)  

Realizar la creacion de la Base de Datos y las consultas necesarias para el correcto funcionamiento del emprendimiento

ENGLISH:
For the culinary pastry enterprise "Desayunos a Domicilio" the following relational model has been embodied:
 
Product (idProducto, Name, date_creation, price)
Themes_Produced (idTema, idProducto)
Composition (idProducto, idComponente, expiration, quantity_component)
Component (idComponent, Description, idPrevailingColor, isCustom, cost)
Recipe (idComponent, step, idIngrediente, measure, amount, elaboration)
Ingredient (idIngredient, name)
Theme (idTheme, Name, color1, color2, color3)
Color (idColor, Name)

Carry out the creation of the Database and the necessary consultations for the correct functioning of the enterprise