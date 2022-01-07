  
*Secuencia de lectura de servicios
  select distinct from matdoc
    inner join            essr on essr.lblni = matdoc.lfbnr
    inner join            eskn on eskn.packno = essr.lblni
    inner join            eskl on eskl.hpackno = essr.packno
                               and eskl.zekkn = eskn.zekkn
    left outer join       esll on esll.packno = eskl.packno
                               and esll.introw = eskl.introw
    left outer join       asmdt on  esll.srvpos = asmdt.asnum