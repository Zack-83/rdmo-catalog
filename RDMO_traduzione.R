library(xml2); library(stringr); library(magrittr); library(tidyverse)
setwd("C:/Users/lanza01/Desktop/lavori in corso/RDMO 2020")

Dateiname <- "rdmo-catalog-master/rdmorganiser/options/rdmo.xml"

Liste_it <- xml_find_all(read_xml(Dateiname),'.//*[@lang="fr"]')
Dokument <- read_xml(Dateiname)
Liste_de <- xml_find_all(Dokument,'.//*[@lang="de"]')
Liste_en <- xml_find_all(Dokument,'.//*[@lang="en"]')
Liste_fr <- xml_find_all(Dokument,'.//*[@lang="fr"]')
# Liste_it <- xml_find_all(Dokument,'.//*[@lang="it"]')

##########################
# nuova tabella traduzione

Übersetzung <- data.frame( cbind( Name = xml_name(Liste_fr),
                                  Pfad = str_replace(xml_path(Liste_fr),"\\[3\\]\\Z","\\[4\\]"),
                                  de = xml_text(Liste_de),
                                  en = xml_text(Liste_en),
                                  fr = xml_text(Liste_fr),
                                  it = ""
) )
# Übersetzung$it[Übersetzung$fr=="jeux de données"] <- "raccolte di dati"
# Übersetzung$it[Übersetzung$fr=="jeu de données"] <- "raccolta di dati"
# Übersetzung$it %<>% gsub("NA","",.)
fix(Übersetzung)
write_tsv(Übersetzung,"Traduzione.tsv")

##########################
# aggiornamento traduzione

Übersetzung <- read_tsv("../Traduzione_catalogo.tsv",na="NA")

xml_set_text(Liste_de,Übersetzung$de)
xml_set_text(Liste_en,Übersetzung$en)
xml_set_text(Liste_fr,Übersetzung$fr)
xml_set_text(Liste_it,Übersetzung$it)
xml_set_attr(Liste_it,"lang","it")
for(.k in 1:length(Liste_fr))  xml_add_sibling( Liste_fr[[.k]],Liste_it[[.k]] )
write_xml(Dokument,"Accidentaccio.xml")
