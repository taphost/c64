0 rem digital rain - three columns with random lengths - basic 2.0 for c64
1 print chr$(147): poke 53281,0: poke 53280,0: poke 646,5:
2 x1=int(rnd(1)*38)+1: x2=int(rnd(1)*38)+1: x3=int(rnd(1)*38)+1
3 l1=int(rnd(1)*19)+5: l2=int(rnd(1)*19)+5: l3=int(rnd(1)*19)+5
4 y1=0: h1=0: y2=0: h2=0: y3=0: h3=0
5 rem y=current position, h=how many chars printed
6 if y1>24 then y1=0: h1=0: x1=int(rnd(1)*38)+1: l1=int(rnd(1)*19)+5
7 if y2>24 then y2=0: h2=0: x2=int(rnd(1)*38)+1: l2=int(rnd(1)*19)+5
8 if y3>24 then y3=0: h3=0: x3=int(rnd(1)*38)+1: l3=int(rnd(1)*19)+5
9 print"{home}";
10 rem process first column
11 fori=1toy1:print"{down}";:next
12 if h1<l1 then c1=int(rnd(1)*90+33):h1=h1+1:else c1=32
13 printtab(x1)chr$(c1)
14 rem process second column
15 print"{home}";
16 fori=1toy2:print"{down}";:next
17 if h2<l2 then c2=int(rnd(1)*90+33):h2=h2+1:else c2=32
18 printtab(x2)chr$(c2)
19 rem process third column
20 print"{home}";
21 fori=1toy3:print"{down}";:next
22 if h3<l3 then c3=int(rnd(1)*90+33):h3=h3+1:else c3=32
23 printtab(x3)chr$(c3)
24 y1=y1+1: y2=y2+1: y3=y3+1
25 fort=1to1:next:rem delay
26 goto6
