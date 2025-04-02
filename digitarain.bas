0 rem digital rain - single column - basic 2.0 for c64
1 print chr$(147): poke 53281,0: poke 53280,0: poke 646,5:
2 x=int(rnd(1)*38)+1
3 l=int(rnd(1)*19)+5:rem length between 5-25
4 y=0:h=0
5 rem y=current position, h=how many chars printed
6 if y>24 then 2:rem restart with new column
7 print"{home}";:fori=1toy:print"{down}";:next
8 if h<l then c=int(rnd(1)*90+33):h=h+1:else c=32
9 printtab(x)chr$(c)
10 y=y+1
11 fort=1to10:next:rem delay
12 goto6
