% Check significancy of RDM against baseline

load('/Users/labuser/Documents/Data/ECoG/Animal_data/RDM_face.mat');
load('/Users/labuser/Documents/Data/ECoG/Animal_data/RDM_face_base.mat');
load('/Users/labuser/Documents/Data/ECoG/Animal_data/RDM_act.mat');
load('/Users/labuser/Documents/Data/ECoG/Animal_data/RDM_act_base.mat');

sig_cor = zeros(11,11,2);
ro = 1;
for st1 = 1:25:275
    cl = 1;
    for st2 = 1:25:275
        mat1 = RDM_face(st1:st1+24,st2:st2+24);
        mat2 = RDM_face_base(st1:st1+24,st2:st2+24);
        if st1 == st2
            mat1 = mat1(itriu(size(mat1),1));
            mat2 = mat2(itriu(size(mat2),1));
        else
            mat1 = reshape(mat1,[1,625]);
            mat2 = reshape(mat2,[1,625]);
        end
        
        [pp] = meanperm(mat1,mat2,10000);
        
        if pp <= 0.0263
            hh= 1;
        else
            hh=0;
        end
        sig_cor(ro,cl,1) = pp;
        sig_cor(ro,cl,2) = hh;
        cl = cl+1;
    end
    ro = ro+1;
end
