
-- make id free for depth min and max
UPDATE gn_imports.dict_fields
SET order_field = order_field + 2 
WHERE order_fild >= 8 AND id_theme = (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info');
-- Prise en compte des nouveaux champs, champs supprimés et renommés de la synthèse
INSERT INTO gn_imports.dict_fields (name_field, fr_label, eng_label, desc_field, type_field, 
  synthese_field, mandatory, autogenerated, nomenclature, id_theme, order_field, display, comment
) VALUES
	('depth_min', 'Profondeur min', '', '', 'integer', TRUE, FALSE, FALSE, FALSE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 8, TRUE, 
    'Correspondance champs standard: profondeurMin'
  ),
	('depth_max', 'Profondeur max', '', '', 'integer', TRUE, FALSE, FALSE, FALSE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 9, TRUE, 
    'Correspondance champs standard: profondeurMax'
  ),
	('place_name', 'Nom du lieu', '', '', 'character varying(500)', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 23, TRUE, 
    'Correspondance champs standard: nomLieu'
  ),
	('precision', 'Précision du pointage (m)', '', '', 'integer', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 24, TRUE, 
    'Correspondance champs standard: precisionGeometrie'
  ),	
	('cd_hab', 'Code habitat', '', '', 'integer', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 25, TRUE, 
    'Correspondance champs standard: CodeHabitatValue'
  ),
	('grp_method', '', '', '', 'character varying(255)', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='statement_info'), 26, TRUE, 
    'Correspondance champs standard: methodeRegroupement'
    ),

  ('additionnal_data', 'Champs additionnels', '', '', 'jsonb', TRUE, FALSE, FALSE, TRUE,
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='occurrence_sensitivity'), 16, 
    FALSE, 'Attributs additionnels'
  ), -- Ajouter un thème dédié à terme et prévoir un widget multiselect qui concatène les infos sous format jsonb ?
	('id_nomenclature_behaviour', 'Comportement', '', '', 'integer', TRUE, FALSE, FALSE, TRUE, 
    (SELECT id_theme FROM gn_imports.dict_themes WHERE name_theme='occurrence_sensitivity'), 15, 
    TRUE, 'Correspondance champs standard: occComportement'
  ),

DELETE FROM gn_imports.dict_fields
WHERE name_field IN ('id_nomenclature_obs_technique', 'sample_number_proof');

UPDATE gn_imports.dict_fields
SET name_field='id_nomenclature_obs_technique'
WHERE name_field='id_nomenclature_obs_meth';

INSERT INTO gn_imports.cor_synthese_nomenclature (mnemonique, synthese_col) VALUES
('OCC_COMPORTEMENT', 'id_nomenclature_behaviour');

UPDATE gn_imports.cor_synthese_nomenclature
SET synthese_col='id_nomenclature_obs_technique'
WHERE mnemonique='METH_OBS';

DELETE FROM gn_imports.cor_synthese_nomenclature
WHERE mnemonique='TECHNIQUE_OBS';


INSERT INTO gn_imports.t_user_errors (error_type,"name",description,error_level) VALUES 
('Erreur d''incohérence','DEPTH_MIN_SUP_ALTI_MAX','profondeur min > profondeur max','ERROR')
,('Erreur de référentiel','CD_HAB_NOT_FOUND','Le cdHab indiqué n’est pas dans le référentiel HABREF ; la valeur de cdHab n’a pu être trouvée dans la version courante du référentiel.','ERROR')
;

UPDATE gn_imports.t_user_errors
SET error_type = 'Erreur d''incohérence' WHERE "name" = 'CD_NOM_NOT_FOUND';


-- rename name field id_nomenclature_bluring
UPDATE gn_imports.dict_fields 
SET fr_label = 'Floutage sur la donnée'
WHERE name_field = 'id_nomenclature_blurring';
