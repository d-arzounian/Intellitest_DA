function [v,l,m]=trans_info(mat)

N=sum(sum(mat,1));

%voisement
mvois=zeros(3,3);
mvois(1,1)=sum(sum([mat(4:6,4:6) mat(4:6,10:16)],1))+sum(sum([mat(10:16,4:6) mat(10:16,10:16)],1));
mvois(1,2)=sum(sum([mat(4:6,1:3) mat(4:6,7:9)],1))+sum(sum([mat(10:16,1:3) mat(10:16,7:9)],1));
mvois(2,1)=sum(sum([mat(1:3,4:6) mat(1:3,10:16)],1))+sum(sum([mat(7:9,4:6) mat(7:9,10:16)],1));
mvois(2,2)=sum(sum([mat(1:3,1:3) mat(1:3,7:9)],1))+sum(sum([mat(7:9,1:3) mat(7:9,7:9)],1));
mvois(:,3)=sum(mvois,2);
mvois(3,:)=sum(mvois,1);
mvois(3,3)=0;

mvois=mvois./N;

infovois=0;
for k=1:2,
    for j=1:2,
        if mvois(k,j)~=0,
            infovois=infovois-mvois(k,j)*log2(mvois(k,3)*mvois(3,j)/mvois(k,j));
        end
    end
end

maxinfovois=0;
for k=1:2,
    if mvois(k,3)~=0,
        maxinfovois=maxinfovois-mvois(k,3)*log2(mvois(k,3));
    end
end

v=infovois/maxinfovois*100;



%Lieu
mlieu=zeros(4,4);
mlieu(1,1)=sum(sum(mat(1:3:13,1:3:13),1));
mlieu(2,1)=sum(sum(mat(2:3:14,1:3:13),1))+sum(sum(mat(16,1:3:13),1));
mlieu(3,1)=sum(sum(mat(3:3:15,1:3:13),1));
mlieu(1,2)=sum(sum(mat(1:3:13,2:3:14),1))+sum(sum(mat(1:3:13,16),1));
mlieu(2,2)=sum(sum(mat(2:3:14,2:3:14),1))+sum(sum(mat(16,2:3:14),1))+sum(sum(mat(2:3:14,16),1))+mat(16,16);
mlieu(3,2)=sum(sum(mat(3:3:15,2:3:14),1))+sum(sum(mat(3:3:15,16),1));
mlieu(1,3)=sum(sum(mat(1:3:13,3:3:15),1));
mlieu(2,3)=sum(sum(mat(2:3:14,3:3:15),1))+sum(sum(mat(16,3:3:15),1));
mlieu(3,3)=sum(sum(mat(3:3:15,3:3:15),1));
mlieu(:,4)=sum(mlieu,2);
mlieu(4,:)=sum(mlieu,1);
mlieu(4,4)=0;

mlieu=mlieu./N;

infolieu=0;
for k=1:3,
    for j=1:3,
        if mlieu(k,j)~=0,
            infolieu=infolieu-mlieu(k,j)*log2(mlieu(k,4)*mlieu(4,j)/mlieu(k,j));
        end
    end
end

maxinfolieu=0;
for k=1:3,
    if mlieu(k,4)~=0,
        maxinfolieu=maxinfolieu-mlieu(k,4)*log2(mlieu(k,4));
    end
end

l=infolieu/maxinfolieu*100;



%mode
mmode=zeros(3,3);
mmode(1,1)=sum(sum([mat(1:6,1:6) mat(1:6,13:14)],1))+sum(sum([mat(13:14,1:6) mat(13:14,13:14)],1));
mmode(1,2)=sum(sum([mat(1:6,7:12) mat(1:6,15:16)],1))+sum(sum([mat(13:14,7:12) mat(13:14,15:16)],1));
mmode(2,1)=sum(sum([mat(7:12,1:6) mat(7:12,13:14)],1))+sum(sum([mat(15:16,1:6) mat(15:16,13:14)],1));
mmode(2,2)=sum(sum([mat(7:12,7:12) mat(7:12,15:16)],1))+sum(sum([mat(15:16,7:12) mat(15:16,15:16)],1));
mmode(:,3)=sum(mmode,2);
mmode(3,:)=sum(mmode,1);
mmode(3,3)=0;

mmode=mmode./N;

infomode=0;
for k=1:2,
    for j=1:2,
        if mmode(k,j)~=0,
            infomode=infomode-mmode(k,j)*log2(mmode(k,3)*mmode(3,j)/mmode(k,j));
        end
    end
end

maxinfomode=0;
for k=1:2,
    if mmode(k,3)~=0,
        maxinfomode=maxinfomode-mmode(k,3)*log2(mmode(k,3));
    end
end

m=infomode/maxinfomode*100;