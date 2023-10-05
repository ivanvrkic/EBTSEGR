/usr/bin/time -f "Max CPU Memory: %M KB\nElapsed: %e sec" \
python -u engcovid.py \
--model GRUoGCN2x2 --win-aggr dense --source EngCOVID --target all \
--framework transductive --hidden 16 --activate softplus --epoch 1 \
--lr 1e-3 --weight-decay 1e-5 --clipper value --patience -1 --seed 56 \
--device cuda
