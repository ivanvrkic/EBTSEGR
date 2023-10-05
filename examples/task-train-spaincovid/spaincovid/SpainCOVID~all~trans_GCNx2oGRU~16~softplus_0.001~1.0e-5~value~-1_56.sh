/usr/bin/time -f "Max CPU Memory: %M KB\nElapsed: %e sec" \
python -u spaincovid.py \
--model GCNx2oGRU --source SpainCOVID --target all --framework transductive \
--hidden 16 --activate softplus --epoch 1 --lr 1e-3 --weight-decay 1e-5 \
--clipper value --patience -1 --seed 56 --device cuda
