Drop table Bul_coll_emp;
/
create table Bul_coll_emp(id number ,name varchar2(30));
/
begin
insert into bul_coll_emp  values(101,'sathish');
insert into bul_coll_emp  values(102,'Mani');
insert into bul_coll_emp  values(103,'Ram');
insert into bul_coll_emp  values(104,'Veera');
insert into bul_coll_emp  values(105,null);
insert into bul_coll_emp  values(106,'Praveen');
insert into bul_coll_emp  values(107,null);
insert into bul_coll_emp  values(108,'vimal');
insert into bul_coll_emp  values(109,'tamil');
insert into bul_coll_emp  values(100,'suresh');
commit;
end;
/

Drop table bul_coll_st_emp;
/

create table bul_coll_st_emp(id number ,name varchar2(30) not null);
/

Drop table err_code_msg;
/

create table err_code_msg (Error_Code varchar2(20),Error_msg varchar2(50));
/

Declare
cursor c is select * from employees;

type ty_nm is table of employees%rowtype;

v_all ty_nm :=ty_nm();
v_count number;
v_all_err_code varchar2(100);
v_all_err_msg varchar2(100);



BEGIN 
open c;
loop
fetch c bulk collect into v_all limit 3;
exit when v_all.count=0;


begin
forall I in v_all.first.. v_all.last SAVE EXCEPTIONS
--Insert into bul_coll_st_emp values v_all(i);

UPDATE bul_coll_st_emp SET NAME=v_all(i).first_name WHERE ID=v_all(i).employee_id;
COMMIT;
EXCEPTION
when others then
v_count :=sql%bulk_exceptions.count;

for I in 1.. v_count
loop
v_all_err_code:=SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;
v_all_err_msg:=SQLERRM ||' '||SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
DBMS_OUTPUT.PUT_LINE(SQL%BULK_EXCEPTIONS(I).ERROR_INDEX);
DBMS_OUTPUT.PUT_LINE(SQLERRM ||' '||SQL%BULK_EXCEPTIONS(I).ERROR_CODE);
--DBMS_OUTPUT.PUT_LINE(v_all_err_msg);
--DBMS_OUTPUT.PUT_LINE(v_all_err_code);
Insert into  err_code_msg(Error_Code,Error_msg) values(v_all_err_code,v_all_err_msg);
END LOOP;
END;
END LOOP;
DBMS_OUTPUT.PUT_LINE(C%ROWCOUNT);
End;
/






DECLARE
 TYPE ids_t IS TABLE OF plch_employees.employee_id%TYPE;

 l_ids  ids_t := ids_t (100, 200, 300);
BEGIN
 FORALL i IN 1 .. l_ids.COUNT --> 1..3
 LOOP
   UPDATE plch_employees
    SET last_name = UPPER (last_name)
   WHERE employee_id = l_ids (i);
 END LOOP;   
END;



DECLARE
 TYPE ids_t IS TABLE OF Bul_coll_emp.id%TYPE;
CURSOR C IS SELECT id,name FROM Bul_coll_emp;
 l_ids  ids_t;

 
BEGIN
 
 OPEN C;
 
 FETCH C BULK COLLECT INTO l_ids;
 
 FORALL i IN 1 .. l_ids.COUNT 

   UPDATE Bul_coll_emp
    SET name = UPPER (name)
   WHERE id = l_ids (i);
 
END;



Bul_coll_emp