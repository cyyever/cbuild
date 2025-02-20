cd ${SRC_DIR}
${sed_cmd} -i -e "/fsspec/d" setup.py
${sed_cmd} -i -e "/num_items_in_batch = num_items_in_batch.item()/s/.item()//g" src/transformers/trainer.py
