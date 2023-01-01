use railway;
-- #Task 1

delimiter $$
create trigger comp_check
before insert
on compartment for each row
begin
declare c int;
declare msg varchar(255);
set msg=('Compartments available in train exceeds 4');
if (select count(*)
from compartment
where train_number=new.train_number)>=4 then
SIGNAL sqlstate '45001'
set message_text=msg;
end if;
end$$
delimiter ;

insert into COMPARTMENT (compartment_no,compartment_type,capacity,availability,train_number) values
('F01','III Class','12','8','62621');
insert into COMPARTMENT ((compartment_no,compartment_type,capacity,availability,train_number) values
('F01','I Class','12','8','62620');
insert into COMPARTMENT (compartment_no,compartment_type,capacity,availability,train_number) values
('G01','II Class','5','8','62620');
insert into COMPARTMENT (compartment_no,compartment_type,capacity,availability,train_number) values
('S01','III Class','14','8','62620');


-- #Task 2

Create table payment_info_backup( transaction_no bigint NOT NULL,
						price int,
                        card_no long,
                        bank  varchar(255),
                        pnr varchar(255),
                        PRIMARY KEY(transaction_no));
                        
set foreign_key_checks=0;

delimiter $$
create trigger payment_backup
before delete
on ticket for each row
begin
declare tn bigint;
declare prc int;
declare cn long;
declare bnk varchar(255);
declare pnr1 varchar(255);
select * into tn,bnk,cn,prc,pnr1
from payment_info 
where pnr=old.pnr;
insert into payment_info_backup(Transaction_No,Bank,Card_No,Price,pnr)
values (tn,bnk,cn,prc,pnr1);
end$$
delimiter ;

delete from ticket where PNR='PNR005';
select * from payment_info_backup;

drop trigger payment_backup;
drop table payment_info_backup;
