create or replace procedure data_migration_sp

is 
begin

Insert into history_table_bank_tb(account_number,
                                   new_balance,
								   old_balance,
								   credit,
								   updated_by,
								   update_on)
                              (select account_number,
							         new_balance,
									 old_balance,
									 credit,
									 updated_by,
									 update_on FROM 
									 target_table_bank_tb where status='H');

delete from target_table_bank_tb where status='H';

update target_table_bank_tb set status='H' where status='I';


update target_table_bank_tb set status='I' where status='A';

insert into target_table_bank_tb(account_number,
                                 old_balance,
								 new_balance,
								 status,
								 updated_by,
								 update_on)
                         ( SELECT  account_number, 
						      old_balance,
							  new_balance,
							  'A',
							  user,
							  systimestamp 
							  from system.source_table_emp);





end;
/